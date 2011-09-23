require 'spec_helper'

describe DataMapper::Mongo::Model do
  # FIXME: Why described_class is nil here? 
  let(:object) do 
    Class.new do
      extend DataMapper::Mongo::Model 
    end
  end

  subject { object.class_eval "#{name}" }

  context 'when name exists in mongo property namespace' do 
    let(:name) { 'ObjectId' }

    it 'should return class from mongo namespace' do
      should == DataMapper::Mongo::Property::ObjectId 
    end
  end

  context 'when name does not exist in mongo property namespace' do
    let(:name) { 'String' }

    it 'should return class from datamapper namespace' do
      should == String
    end
  end

  context 'when name is "Serial"' do
    let(:name) { 'Serial' }

    it 'should return ObjectId for compatibillity' do
      should == DataMapper::Mongo::Property::ObjectId
    end
  end
end
