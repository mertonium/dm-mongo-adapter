require 'spec_helper'

describe DataMapper::Mongo::Adapter do
  describe '#connection' do
    it "needs integration spec" do
      pending
    end
  end
 #if DO_CONNECT
 #  describe "#connection" do
 #    let(:adapter) { DataMapper::Mongo::Adapter.new(REPOS['default']) }
 #    subject { adapter.send(:connection) }
 #    it { should be_a ::Mongo::Connection }
 #    its(:host_to_try) { should == ['localhost', 27017] }
 #    its(:logger) { should == DataMapper.logger }
 #  end
 #end
end
