module ConnectionHelper

  def setup_connection
    uri = if ENV['TRAVIS']
      'mongo://localhost:27017/test'
    elsif ENV['MONGO_URL']
      ENV['MONGO_URL']
    else
      mongod_start
      mongod_wait
      'mongo://localhost:27017/test'
    end
    DataMapper.setup :default,uri
  end

  def teardown_connection
    DataMapper.repository(:default).adapter.close_connection
    DataMapper::Repository.adapters.delete :default
    mongod_stop if mongod_active?
  end
end
