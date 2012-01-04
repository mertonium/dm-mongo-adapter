module DataMapper::Mongo::Spec
  module ReplicaSetHelper
    def wait_for_primary(name,port,max_retries = 60)
      1.upto(max_retries) do |run|
        connection = Mongo::Connection.new 'localhost',port
        return if connection.primary?
        connection.close
        $stderr.puts "mongod #{name.inspect} is not primary yet waiting a second (retry #{sprintf("%02d/%02d",run,max_retries)})"
        sleep 1
      end
      raise "could not connect to primary"
    end
   
    def start_replica_set
      port_a = 27117
      port_b = 27118
      port_c = 27119

      mongod_start :a,port_a,%W(--replSet dm-mongo-adapter)
      mongod_start :b,port_b,%W(--replSet dm-mongo-adapter)
      mongod_start :c,port_c,%W(--replSet dm-mongo-adapter)
   
      config = <<-JSON
        {
          "_id" : "dm-mongo-adapter",
          "version" : 1,
          "members" : [
            {
              "_id" : 0,
              "priority" : 100,
              "host" : "localhost:#{port_a}"
            },
            {
              "_id" : 1,
              "priority" : 1,
              "host" : "localhost:#{port_b}"
            },
            {
              "_id" : 2,
              "priority" : 1,
              "host" : "localhost:#{port_c}"
            }
          ]
        }
      JSON
   
      mongod_wait :a
   
      Process.wait spawn %W(mongo localhost:#{port_a} --eval #{"rs.initiate(#{config});"}) << { :err => :out, :out => '/dev/null' }
      $stderr.puts "mongodb replica set was initiated waiting for node to become primary"

   
      wait_for_primary :a,port_a
   
      [
        ['localhost',port_a],
        ['localhost',port_b]
      ]
    end
   
    def teardown_replica_set
      mongod_stop :a
      mongod_stop :b
      mongod_stop :c
    end

    def with_running_replica_set
      if RUBY_PLATFORM == 'java'
        describe 'replica set specs' do
          specify 'are not supported' do
            pending 'under jruby'
          end
        end
        return
      end
      before :all do
        @replica_set = start_replica_set
      end
      
      let(:replica_set) { @replica_set }
      
      yield
      
      after :all do
        teardown_replica_set
      end
    end
  end
end
