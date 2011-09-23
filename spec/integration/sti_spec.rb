require 'spec_helper'

describe 'Single Table Inheritance' do
  with_connection do
    before :all do
      class ::Person
        include DataMapper::Mongo::Resource
   
        property :id, ObjectId
        property :name, String
        property :job, String
        property :type, Discriminator
      end
   
      class ::Male < Person; end
      class ::Father < Male; end
      class ::Son < Male; end

      DataMapper.finalize
    end
   
    before :each do
      reset_db
    end
   
    it 'should have a type property that reflects the class' do
      [Person, Male, Father, Son].each_with_index do |model, i|
        object = model.create_or_raise(:name => "#{model} #{i}")
        object.type.should == model
      end
    end
   
    it 'should parent should return an instance of the child when type is explicitly specified' do
      [Person, Male, Father, Son].each_with_index do |model, i|
        object = model.create_or_raise(:name => "#{model} #{i}")
        object.reload
        object.should be_instance_of(model)
      end
    end
   
    it 'should discriminate types during reads' do
      father1 = Father.create_or_raise(:name => '1')
      father2 = Father.create_or_raise(:name => '2')
   
      fathers = Father.all
   
      fathers.should == [father1, father2]
   
      fathers.each do |father|
        father.type.should be(Father)
        father.should be_instance_of(Father)
      end
    end
  end
end
