module DataMapper
  module Mongo
    class Property
      # Database references are references from one document (object) to
      # another within a database. A database reference is a standard embedded
      # object: this is a MongoDB convention, not a special type.
      #
      # The DBRef is made available via your model as a String.
      #
      # @see http://www.mongodb.org/display/DOCS/DB+Ref
      #
      # @api public
      class DBRef < DataMapper::Property::Object
        include DataMapper::Property::PassThroughLoadDump

        primitive ::BSON::ObjectId
        required false

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
      end # DBRef
    end # Property
  end # Mongo
end # DataMapper
