module DataMapper
  module Mongo
    class Property
      # Each object (document) stored in Mongo DB has an _id field as its
      # first attribute.  This is an object id.  It must be unique for each
      # member of a collection (this is enforced if the collection has an _id
      # index, which is the case by default).
      #
      # The database will assign an _id if an object being inserted into a
      # collection does not have one.
      #
      # The _id may be of any type as long as it is a unique value.
      #
      # @see http://www.mongodb.org/display/DOCS/Object+IDs
      #
      # @api public
      class ObjectId < DBRef
        key true
        field '_id'
      end # ObjectId
    end # Property
  end # Mongo
end # DataMapper
