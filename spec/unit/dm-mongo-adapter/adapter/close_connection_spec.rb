require 'spec_helper'

describe DataMapper::Mongo::Adapter, '#close_connection' do
  let(:object) { described_class.new(:default,{}) }

  subject { object.close_connection }


  context 'when adapter is connected' do
    let(:connection) { mock(:close => true) }

    before do
      object.instance_variable_set(:@connection,connection)
    end

    it 'should close the connection' do
      connection.should_receive(:close)
      subject
    end

    it 'should remove the connection' do
      subject
      object.instance_variable_get(:@connection).should be_false
    end
  end

  context 'when adapter is not connected' do
    it 'should be a noop' do
      subject
    end
  end
end
