module DataMapper
  module Mongo
    module Property
      # Shared behaviour for all properties using BSON::ObjectId as primitive.
      module BsonObjectId
        # Returns the ObjectId as a string
        #
        # @return [String]
        #
        # @api semipublic
        def typecast_to_primitive(value)
          case value
          when ::String
            ::BSON::ObjectId.from_string(value)
          else
            raise ArgumentError.new('+value+ must String')
          end
        end
     
        # @api semipublic
        def valid?(value, negated = false)
          value.nil? || primitive?(value)
        end
      end
    end
  end
end
