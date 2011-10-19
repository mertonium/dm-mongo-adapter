class Virtus::Coercion::String
  def self.to_bson_object_id(value)
    ::BSON::ObjectId.from_string(value)
  end
end
