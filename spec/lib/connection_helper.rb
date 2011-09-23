module ConnectionHelper

  def setup_connection
    uri = if ENV['TRAVIS']
      'mongo://localhost:27017/test'
    elsif ENV['MONGO_URL']
      ENV['MONGO_URL']
    else
      start_mongodb
      'mongo://localhost:27017'
    end
    DataMapper.setup :default,uri
  end

  def teardown_connection
    DataMapper.repository(:default).adapter.close_connection
    DataMapper::Repository.adapters.delete :default
    stop_mogodb
  end

  def stop_mongodb
    Process.kill 'INT', @mongod_pid if @mongod_pid
  end
end
