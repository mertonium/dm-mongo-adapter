module DataMapper
  module Mongo
    module Property
      class Hash < DataMapper::Property::Object
        load_as ::Hash
        dump_as ::Hash

        # FIXME: Replace with Virtus::Coercion::Array.to_hash ?
        def typecast(value)
          case value
          when NilClass
            nil
          when ::Hash
            value
          when ::Array
            value.empty? ? {} : {value.first => value.last}
          end
        end
      end #Array
    end # Property
  end # Mongo
end # DataMapper
