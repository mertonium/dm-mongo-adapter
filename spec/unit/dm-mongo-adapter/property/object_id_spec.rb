require 'spec_helper'

describe DataMapper::Mongo::Property::ObjectId do
  let(:model)     { Class.new include DataMapper::Mongo::Resource } }
  let(:property)  { model.property(:id, DataMapper::Mongo::Property::ObjectId) }

  it_should_behave_like 'an ObjectId type'

  describe '#child_key' do
    it 'should return DataMapper::Mongo::Property::ForeignObjectId' do
      property.to_child_key.should == DataMapper::Mongo::Property::ForeignObjectId
    end
  end

  describe '#required' do
    it 'should not be required' do
      property.required.should be_false
    end
  end
end
