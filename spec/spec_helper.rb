require 'pathname'
require 'spec'
require 'dm-core'
require 'dm-mongo-adapter'
require 'dm-annoing-modificators'

MONGO_SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
$LOAD_PATH.unshift(MONGO_SPEC_ROOT.parent.join('lib').to_s)

Pathname.glob((MONGO_SPEC_ROOT + 'lib/**/*.rb').to_s).each { |file| require file }
Pathname.glob((MONGO_SPEC_ROOT + '**/shared/**/*.rb').to_s).each { |file| require file }

# Define the repositories used by the specs. Override the defaults by
# supplying ENV['DEFAULT_SPEC_URI'] or ENV['AUTH_SPEC_URI'].


Spec::Runner.configure do |config|
  config.include DataMapper::Mongo::Spec::CleanupModels
  config.include ResetHelper
  config.include ProcessHelper
  config.include ConnectionHelper
  config.include ReplicaSetHelper
  config.include MongodHelper
  config.extend ConnectionManagement
  config.extend ReplicaSetManagement

  config.before(:all) do
    models  = DataMapper::Model.descendants.to_a
    cleanup_models(*models)
  end
end
