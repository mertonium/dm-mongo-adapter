require 'spec_helper'

# FIXME: This is the worst spec I'v ever written. Magical and hackish, pls improve it.

describe DataMapper::Mongo::Adapter,'#connection' do
  let(:object) { described_class.new(:default,options) }

  subject { object.send :connection }

  shared_examples_for 'a mongo connection setup' do
    it 'should create the correct instance with additional options' do
      expected_class.should_receive(:new).with(*(expected_arguments+[:logger => DataMapper.logger]))
      subject
    end

    it 'should pass any extra option to mogo' do
      options[:read]=:secondary
      expected_class.should_receive(:new).with(*(expected_arguments+[:logger => DataMapper.logger,:read => :secondary]))
      subject
    end
  end

  context 'when seeds are not in options' do
    let(:options) { { :host => 'example.net', :port => 27017 } }
    let(:expected_class) { Mongo::Connection }
    let(:expected_arguments) { ['example.net',27017] }

    it_should_behave_like 'a mongo connection setup'
  end

  context 'when seeds are in options' do
    let(:options) { { :seeds => [['a.example.net',27017],['b.example.net']] } }
    let(:expected_class) { Mongo::ReplSetConnection }
    let(:expected_arguments) { [['a.example.net',27017],['b.example.net',27017]] }

    it_should_behave_like 'a mongo connection setup'
  end
end
