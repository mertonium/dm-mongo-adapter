module DataMapper::Mongo::Spec
  module MongodHelper
    MONGOD_MINIMAL_IMPACT_OPTS = %w(
      --nojournal 
      --noauth 
      --nssize 1 
      --noprealloc 
      --smallfiles 
      --bind_ip localhost
      --oplogSize 1
    )

    def mongod_start(name = :default,port = 27017,options = [])
      dbpath = MONGO_SPEC_ROOT + '..' + 'tmp' + name.to_s
      FileUtils.rm_rf(dbpath)
      FileUtils.mkdir_p(dbpath)
      command = %W(mongod --dbpath #{dbpath} --port #{port})
      command.concat(MONGOD_MINIMAL_IMPACT_OPTS)
      command.concat(options)
      command << { :err => :out,:out => [dbpath + 'stdout.log','w'] }
      mongod_pids[name] = spawn(command)
      mongod_ports[name] = port
      $stderr.puts "mongod #{name.inspect} at port #{port} started"
    end

    def mongod_active?(name = :default)
      mongod_pids.key?(name)
    end

    def mongod_wait(name = :default)
      loop do
        begin
          connection = 
            Mongo::Connection.new('localhost', mongod_ports.fetch(name))
          connection.close
          return
        rescue Mongo::ConnectionFailure
          $stderr.puts "mongod not ready yet, waiting a second"
          sleep 1
        end
      end
    end

    def mongod_stop(name = :default)
      pid = mongod_pids.fetch(name) do 
        raise "Running mongod instance with name #{name.inspect} was not found"
      end
      Process.kill('INT', pid)
      mongod_pids.delete(name)
      port = mongod_ports.delete(name)
      $stderr.puts "mongod #{name.inspect} at port #{port} stopped"
    end

    def mongod_pids
      @mongod_pids ||= {}
    end

    def mongod_ports
      @mongod_ports ||= {}
    end
  end
end
