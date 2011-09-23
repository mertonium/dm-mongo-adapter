require 'pathname'
require 'spec'
require 'dm-core'
require 'dm-mongo-adapter'
require 'dm-annoing-modificators'

MONGO_SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
$LOAD_PATH.unshift(MONGO_SPEC_ROOT.parent.join('lib').to_s)

DO_CONNECT = !!ENV['DO_CONNECT']

Pathname.glob((MONGO_SPEC_ROOT + 'lib/**/*.rb').to_s).each { |file| require file }
Pathname.glob((MONGO_SPEC_ROOT + '**/shared/**/*.rb').to_s).each { |file| require file }

# Define the repositories used by the specs. Override the defaults by
# supplying ENV['DEFAULT_SPEC_URI'] or ENV['AUTH_SPEC_URI'].

module ResetHelper
  def reset_db
    DataMapper.repository.adapter.send(:database).collections.each do |collection|
      next if collection.name =~ /^system/
      collection.drop
    end
  end
end

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
    #DataMapper.repository(:default).adapter.connection.close
    #DataMapper::Repository.adapters.delete :default
  end
end

module ConnectionManagement
  def with_connection
    if ENV['MONGO_URL'] or ENV['TRAVIS']
      before :all do
        setup_connection
      end
      yield
      after :all do
        teardown_connection
      end
    end
  end
end

Spec::Runner.configure do |config|
  config.include(DataMapper::Mongo::Spec::CleanupModels)
  config.include(ResetHelper)
  config.include(ConnectionHelper)
  config.extend(ConnectionManagement)

  config.before(:all) do
    models  = DataMapper::Model.descendants.to_a
    cleanup_models(*models)
  end
end
