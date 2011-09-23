module DataMapper::Mongo::Spec
  module ReplicaSetHelper
    def wait_for_primary(name,port)
      loop do
        connection = Mongo::Connection.new 'localhost',port
        return if connection.primary?
        connection.close
        $stderr.puts "mongod #{name.inspect} is not primary yet waiting a second"
        sleep 1
      end
    end
   
    def start_replica_set
      port_a = 27117
      port_b = 27118
      port_c = 27119
    #--replSet dm-mongo-adapter 
    #
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
   
      Kernel.system *%W(mongo localhost:#{port_a} --eval #{"rs.initiate(#{config});"})
   
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
  end
end
