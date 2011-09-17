require 'spec_helper'

describe DataMapper::Mongo::Adapter,'.new' do 
  let(:object) { described_class }
  subject { object.new(name,options) }

  let(:name) { :default }

  let(:dbopts) { subject.options }

  context 'when path has a forward slash prefix' do
    let(:options) { { :host => 'example.net',:path => '/some-db' } }


    it 'should strip the forwad slash' do
      dbopts[:database].should == 'some-db'
    end
  end

  context 'when :seeds are present' do
    context 'and a seed has no port' do
      context 'and a database port is set' do
        let(:options) { { :seeds => [%w(a.example.net)], :port => 20000 } }
         it 'should apply port as default' do
           dbopts[:seeds].should == [['a.example.net',20000]]
         end
      end

      context 'and a database port is not set' do
        let(:options) { { :seeds => [%w(a.example.net)] } }

        it 'should use the default port 27017' do
          dbopts[:seeds].should == [['a.example.net',27017]]
        end
      end
    end
  end
end
