# FIXME: There must be a better place for this!
class Virtus::Coercion::String
  def self.to_bson_object_id(value)
    case value
    when ::String
      ::BSON::ObjectId.from_string(value)
    else
      raise ArgumentError.new('+value+ must String')
    end
  end
end
