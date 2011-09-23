module MongodHelper
  MONGOD_MINIMAL_IMPACT_OPTS = %w(
    --nojournal 
    --noauth 
    --nssize 1 
    --noprealloc 
    --smallfiles 
    --bind_ip localhost
  )

  def mongod_start(name = :default,options = [])
    dbpath = MONGO_SPEC_ROOT + '..' + 'tmp' + name.to_s
    FileUtils.rm_rf dbpath
    FileUtils.mkdir_p dbpath
    command = %W(mongod --dbpath #{dbpath})
    command.concat MONGOD_MINIMAL_IMPACT_OPTS
    command.concat options
    command << { :err => :out,:out => [dbpath + 'stdout.log','w'] }
    mongod_pids[name] = spawn command
  end

  def mongod_wait(port)
    loop do
      begin
        connection = Mongo::Connection.new 'localhost', port
        connection.close
        return
      rescue Mongo::ConnectionFailure
        $stderr.puts "mongod not ready yet, waiting a second"
        sleep 1
      end
    end
  end

  def mongod_stop(name = :default)
    Process.kill 'INT', mongod_pids.fetch(name) { raise "Running mongod instance with name #{name.inspect} was not found" }
    mongod_pids.delete name
  end

  def mongod_pids
    @mongod_pids ||= {}
  end
end
