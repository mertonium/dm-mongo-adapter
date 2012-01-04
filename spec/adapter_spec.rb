require 'spec_helper'

require 'dm-core/spec/shared/adapter_spec'

require 'dm-migrations'
require 'dm-mongo-adapter/spec/setup'

ENV['ADAPTER']          = 'mongo'
ENV['ADAPTER_SUPPORTS'] = 'all'

describe 'DataMapper::Adapters::MongoAdapter' do
  with_connection do
    let(:repository) { DataMapper.repository(:default) }
    let(:adapter)    { DataMapper.repository(repository.adapter) }

    # This is the mongodb specific Heffalup model. 
    let(:heffalump_model) do
      Class.new do
        include DataMapper::Resource
        property :id,        DataMapper::Mongo::Property::ObjectId
        property :color,     DataMapper::Property::String
        property :num_spots, DataMapper::Property::Integer
        property :striped,   DataMapper::Property::Boolean

        # This is needed for DataMapper.finalize
        def self.name; 'Heffalump'; end
      end
    end
    
    it_should_behave_like 'An Adapter'
  end
end
