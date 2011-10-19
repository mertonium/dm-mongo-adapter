module DataMapper
  module Mongo
    module Property
      # FormeignObjectId references other objects in your relations
      # It uses BSON::ObjectId to store the id of the related object.
      #
      # The ObjectId is made available via your model as a String.
      #
      # It does not implement the mongodb DBRef convention.
      # @see http://www.mongodb.org/display/DOCS/Database+References
      #
      # @api public
      class ForeignObjectId < DataMapper::Property::Object
        load_as ::BSON::ObjectId
        dump_as ::BSON::ObjectId
        coercion_method :to_bson_object_id
        required false
      end # ForeignObjectId
    end # Property
  end # Mongo
end # DataMapper
