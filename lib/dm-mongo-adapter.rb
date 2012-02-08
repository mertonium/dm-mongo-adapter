# dm-core depends on virtus
# and virtus needs backports for 1.8
# Sonce virtus does not pull or load 
# backports we are doing it here
#
p RUBY_VERSION
if RUBY_VERSION < '1.9.0'
  require 'backports'
end

require 'mongo'

require 'dm-core'
require 'dm-aggregates'

require 'dm-mongo-adapter/version'
require 'dm-mongo-adapter/query'
require 'dm-mongo-adapter/query/java_script'

require 'dm-mongo-adapter/property/foreign_object_id'
require 'dm-mongo-adapter/property/object_id'
require 'dm-mongo-adapter/property/array'
require 'dm-mongo-adapter/property/hash'

require 'dm-mongo-adapter/support/class'
require 'dm-mongo-adapter/support/date'
require 'dm-mongo-adapter/support/date_time'
require 'dm-mongo-adapter/support/object'
require 'dm-mongo-adapter/support/coercions'

require 'dm-mongo-adapter/migrations'
require 'dm-mongo-adapter/model'
require 'dm-mongo-adapter/resource'
require 'dm-mongo-adapter/migrations'
require 'dm-mongo-adapter/modifier'

require 'dm-mongo-adapter/aggregates'
require 'dm-mongo-adapter/adapter'
