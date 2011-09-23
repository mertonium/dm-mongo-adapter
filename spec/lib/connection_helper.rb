module ConnectionHelper

  def ensure_connection
    unless $connection
      setup_connection
      $connection = true
    end
  end

  def setup_connection(name = :default)
    uri = if ENV['TRAVIS']
      'mongo://localhost:27017/test'
    elsif ENV['MONGO_URL']
      ENV['MONGO_URL']
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
end
