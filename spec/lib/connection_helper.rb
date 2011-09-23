module ConnectionHelper
  def setup_connection
    uri = if ENV['TRAVIS']
      'mongo://localhost:27017/test'
    elsif ENV['MONGO_URL']
      ENV['MONGO_URL']
    else
      raise 'Not running on travis ci and no MONGO_URL in env, cannot setup connection'
    end
    DataMapper.setup :default,uri
  end

  def teardown_connection
    DataMapper.repository(:default).adapter.close_connection
    DataMapper::Repository.adapters.delete :default
  end
end
