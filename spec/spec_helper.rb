require 'pathname'
require 'spec'
require 'dm-core'
require 'dm-mongo-adapter'

MONGO_SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
$LOAD_PATH.unshift(MONGO_SPEC_ROOT.parent.join('lib').to_s)

DO_CONNECT = !!ENV['DO_CONNECT']

Pathname.glob((MONGO_SPEC_ROOT + 'lib/**/*.rb').to_s).each { |file| require file }
Pathname.glob((MONGO_SPEC_ROOT + '**/shared/**/*.rb').to_s).each { |file| require file }

# Define the repositories used by the specs. Override the defaults by
# supplying ENV['DEFAULT_SPEC_URI'] or ENV['AUTH_SPEC_URI'].

module ConnectionHelper
  def setup_connection
    uri = if ENV['TRAVIS_CI']
      'mongo://localhost:27017'
    elsif ENV['MONGO_URL']
      ENV['MONGO_URL']
    else
      raise 'Not running on travis ci and no MONGO_URL in env, cannot setup connection'
    end
    DataMapper.setup :default,uri
  end

  def teardown_connection
    DataMapper.repository(:default).adapter.connection.close
  end

  def with_connection
    if ENV['MONGO_URL'] or ENV['TRAVIS_CI']
      setup_connection
      yield
      teardown_connection
    end
  end
end

Spec::Runner.configure do |config|
  config.include(DataMapper::Mongo::Spec::CleanupModels)
  config.extend(ConnectionHelper)

  config.before(:all) do
    models  = DataMapper::Model.descendants.to_a
    cleanup_models(*models)
  end
end
