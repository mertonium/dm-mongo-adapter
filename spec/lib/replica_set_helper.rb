module ReplicaSetHelper
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
  #--replSet dm-mongo-adapter 
  #
    mongod_start :a,%W(--port #{port_a} --replSet dm-mongo-adapter)
    mongod_start :b,%W(--port #{port_b} --replSet dm-mongo-adapter)
    mongod_start :c,%W(--port #{port_c} --replSet dm-mongo-adapter)

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

    mongod_wait port_a

    Kernel.system *%W(mongo localhost:#{port_a} --eval #{"rs.initiate(#{config});"})

    wait_for_primary port_a

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
