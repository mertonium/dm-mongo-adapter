module DataMapper
  module Mongo
    module Property
      # FormeignObjectId references other objects in your relations
      # It uses BSON::ObjectId to store the id of the related object.
      #
      # The ObjectId is made available via your model as a String.
      #
      # It does not implement mogos DBRef Convention.
      # @see http://www.mongodb.org/display/DOCS/Database+References
      #
      # @api public
      class ForeignObjectId < DataMapper::Property::Object
        include BsonObjectId
        primitive ::BSON::ObjectId
        required false
      end # DBRef
    end # Property
  end # Mongo
end # DataMapper
