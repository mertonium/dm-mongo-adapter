require 'spec_helper'

describe DataMapper::Mongo::Property::ForeignObjectId do
  let(:model) do 
    Class.new do 
      include DataMapper::Mongo::Resource
      property :id,DataMapper::Mongo::Property::ObjectId
    end
  end

  let(:property) { model.property(:foreign_id, DataMapper::Mongo::Property::ForeignObjectId) }

  it_should_behave_like 'an ObjectId type'
end
