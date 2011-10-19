class Virtus::Coercion::String
  def self.to_bson_object_id(value)
    ::BSON::ObjectId.from_string(value)
  end
end

# Was a surprise Virtus did not define this class!
module Virtus
  class Coercion
    class Array < Virtus::Coercion::Object
      primitive ::Array
      def self.to_hash(value)
        value.empty? ? {} : {value.first => value.last}
      end
    end
  end
end
