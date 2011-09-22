require 'pathname'
require 'spec'

MONGO_SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
$LOAD_PATH.unshift(MONGO_SPEC_ROOT.parent.join('lib').to_s)

DO_CONNECT = !!ENV['DO_CONNECT']

require 'dm-mongo-adapter'

Pathname.glob((MONGO_SPEC_ROOT + 'lib/**/*.rb').to_s).each { |file| require file }
Pathname.glob((MONGO_SPEC_ROOT + '**/shared/**/*.rb').to_s).each { |file| require file }

# Define the repositories used by the specs. Override the defaults by
# supplying ENV['DEFAULT_SPEC_URI'] or ENV['AUTH_SPEC_URI'].

REPOS = {
  'default' => 'mongo://localhost/dm-mongo-test',
  'auth'    => 'mongo://dmm-auth:dmm-password@localhost/dm-mongo-test-auth'
}

REPOS.each do |name, default|
  connection_string = ENV["#{name.upcase}_SPEC_URI"] || default

  DataMapper.setup(name.to_sym, connection_string)
  REPOS[name] = connection_string  # ensure *_SPEC_URI is saved
end

REPOS.freeze

module ConnectionHelper
  def with_connection
    if ENV['DO_CONNECT']
      yield
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
