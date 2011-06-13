require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe DataMapper, 'associations' do
  before :all do
    class ::User
      include DataMapper::Mongo::Resource

      property :id, ObjectId
      property :name, String
      property :age, Integer
    end

    class ::Group
      include DataMapper::Mongo::Resource

      property :id, ObjectId
      property :name, String
    end

    User.belongs_to :group
    Group.has Group.n, :users
    DataMapper.finalize
  end

  describe 'User model' do
    it 'should have an group_id property' do
      User.properties[:group_id].should be_kind_of(DataMapper::Mongo::Property::ForeignObjectId)
    end
  end

  describe '.belongs_to' do
    let!(:john) { User.create(:name => 'john', :age => 101) }
    let!(:jane) { User.create(:name => 'jane', :age => 102) }
    let!(:group) { Group.create(:name => 'dm hackers') }

    it 'should set parent object id as the foreign object id' do
      john.update(:group => group)
      john.group_id.should == group.id
    end

    it 'should fetch parent object' do
      user = User.create(:name => 'jane')
      user.group_id = group.id
      user.group.should == group
    end

    it 'should work with SEL' do
      users = User.all(:name => /john|jane/)

      users.each { |u| u.update(:group_id => group.id) }

      users.each do |user|
        user.group.should_not be_nil
      end
    end
  end

  describe 'has many' do
    let!(:john) { User.create(:name => 'john', :age => 101) }
    let!(:jane) { User.create(:name => 'jane', :age => 102) }
    let!(:group) { Group.create(:name => 'dm hackers', :users => [john,jane]) }

    it 'should get children' do
      group.users.size.should == 2
    end

    it 'should add new children with <<' do
      user = User.new(:name => 'kyle')
      group.users << user
      user.group_id.should == group.id
      group.users.size.should == 3
    end

    it 'should replace children' do
      user = User.create(:name => 'stan')
      group.users = [user]
      group.users.size.should == 1
      group.users.first.should == user
    end

    it 'should fetch children matching conditions' do
      users = group.users.all(:name => 'john')
      users.size.should == 1
    end
  end
end
