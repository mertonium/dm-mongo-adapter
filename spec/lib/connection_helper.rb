module DataMapper::Mongo::Spec
  module ConnectionHelper
    def ensure_connection
      unless $connection
        setup_connection
        $connection = true
        at_exit do
          teardown_connection
        end
      end
    end
   
    def setup_connection(name = :default)
      uri = if ENV['TRAVIS']
        'mongo://localhost:27017/test'
      elsif ENV['MONGO_URL']
        ENV['MONGO_URL']
      elsif RUBY_PLATFORM == 'java'
        raise 'Automatic mongodb management is not possible under jruby pls provide a MONGO_URL env variable'
      else
        mongod_start name
        mongod_wait name
        'mongo://localhost:27017/test'
      end
      DataMapper.setup name,uri
    end
   
    def teardown_connection(name = :default)
      repo = DataMapper.repository(name)
      if repo
        repo.adapter.close_connection
        DataMapper::Repository.adapters.delete name
      end
      mongod_stop(name) if mongod_active?(name)
    end
   
    def teardown_connections
      DataMapper::Repository.adapters.keys.each do |name|
        teardown_connection name
      end
    end
  end
end
