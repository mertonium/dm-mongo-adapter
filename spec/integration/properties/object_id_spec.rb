require 'spec_helper'

describe DataMapper::Mongo::Property::ObjectId do
  before(:all) do
    class User
      include DataMapper::Mongo::Resource
      property :id,       ObjectId
    end

  end
  let(:property_class) { DataMapper::Mongo::Property::ObjectId }
  let(:property) { User.properties[:id] }

  it_should_behave_like 'an ObjectId type'
end
