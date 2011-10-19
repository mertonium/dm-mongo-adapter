module DataMapper
  module Mongo
    module Property
      class Hash < DataMapper::Property::Object
        load_as ::Hash
        dump_as ::Hash
        coercion_method :to_hash
      end #Array
    end # Property
  end # Mongo
end # DataMapper
