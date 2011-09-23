module ReplicaSetHelper
  def spawn(*arguments)
    if Process.respond_to? :spawn
      Process.spawn *arguments
    else
      if arguments.last.kind_of? Hash
        opts = arguments.pop
      end
      fork do |child|
        Kernel.exec *arguments
      end
    end
  end

  def wait_for_connection(port)
    loop do
      begin
        connection = Mongo::Connection.new 'localhost', port
        connection.close
        return
      rescue Mongo::ConnectionFailure
        $stderr.puts "mongodb not ready yet, waiting a second"
        sleep 1
      end
    end
  end

  def wait_for_primary(port)
    loop do
      begin
        connection = Mongo::Connection.new 'localhost',port
        return if connection.primary?
        puts "mongodb is not primary yet waiting a second"
        connection.close
      rescue Mongo::ConnectionFailure
        $stderr.puts "mongodb not ready yet, waiting a second"
      end
      sleep 1
    end
  end

  def start_replica_set
    port_a = 27117
    port_b = 27118
    port_c = 27119

    dbdir_a = MONGO_SPEC_ROOT + '..' + 'tmp' + 'mongo-a'
    dbdir_b = MONGO_SPEC_ROOT + '..' + 'tmp' + 'mongo-b'
    dbdir_c = MONGO_SPEC_ROOT + '..' + 'tmp' + 'mongo-c'

    FileUtils.rm_rf dbdir_a
    FileUtils.rm_rf dbdir_b
    FileUtils.rm_rf dbdir_c
    FileUtils.mkdir_p dbdir_a
    FileUtils.mkdir_p dbdir_b
    FileUtils.mkdir_p dbdir_c

    options = %w(
      --replSet dm-mongo-adapter 
      --nojournal 
      --noauth 
      --nssize 1 
      --noprealloc 
      --smallfiles 
      --bind_ip localhost
    )

    arguments_a = ['mongod'] + options + %W(--dbpath #{dbdir_a} --port #{port_a}) << { :err => :out } #,:out => [dbdir_a + 'stdout.log','w'] }
    arguments_b = ['mongod'] + options + %W(--dbpath #{dbdir_b} --port #{port_b}) << { :err => :out,:out => [dbdir_b + 'stdout.log','w'] }
    arguments_c = ['mongod'] + options + %W(--dbpath #{dbdir_c} --port #{port_c}) << { :err => :out,:out => [dbdir_c + 'stdout.log','w'] }

    @pid_a = spawn *arguments_a
    @pid_b = spawn *arguments_b
    @pid_c = spawn *arguments_c


    config = <<-JSON
      {
        "_id" : "dm-mongo-adapter",
        "version" : 1,
        "members" : [
          {
            "_id" : 0,
            "priority" : 100,
            "host" : "localhost:#{port_a}"
          }
        ]
      }
    JSON

    wait_for_connection port_a

    Kernel.system 'mongo',"localhost:#{port_a}/admin",'--eval',"rs.initiate(#{config})"
    wait_for_primary port_a
    Kernel.system 'mongo',"localhost:#{port_a}/admin",'--eval',%Q(rs.add("localhost:#{port_b}"))
    Kernel.system 'mongo',"localhost:#{port_a}/admin",'--eval',%Q(rs.add("localhost:#{port_c}"))
    wait_for_primary port_a

    [
      ['localhost',port_a],
      ['localhost',port_b]
    ]
  end

  def teardown_replica_set
    Process.kill 'INT', @pid_a if @pid_a
    Process.kill 'INT', @pid_b if @pid_b
  end
end
