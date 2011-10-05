require 'spec_helper'

describe DataMapper::Mongo::Property::ForeignObjectId do
  with_connection do
    let(:property_class) { DataMapper::Mongo::Property::ForeignObjectId }
   
    let(:user_model) do
      Class.new do
        include DataMapper::Mongo::Resource
        property :id,       DataMapper::Mongo::Property::ObjectId
        property :group_id, DataMapper::Mongo::Property::ForeignObjectId
      end
   
    end
   
    let(:property) { user_model.properties[:group_id] }
   
    it 'should set default field to property name' do
      property.field.should == 'group_id'
    end
   
    it 'should not default to be a key' do
      property.key?.should be_false
    end
   
    it_should_behave_like 'an ObjectId type'
  end
end
