module DataMapper
  module Mongo
    module Property
      class Array < DataMapper::Property::Object
        load_as ::Array
        dump_as ::Array
        coercion_method :to_array
      end
    end # Property
  end # Mongo
end # DataMapper
