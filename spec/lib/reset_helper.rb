module DataMapper::Mongo::Spec
  module ResetHelper
    def reset_db
      DataMapper.repository.adapter.send(:database).collections.each do |collection|
        next if collection.name =~ /^system/
        collection.drop
      end
    end
  end
end
