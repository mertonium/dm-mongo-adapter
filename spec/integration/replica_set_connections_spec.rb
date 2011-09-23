require 'spec_helper'

describe 'replica set connections' do
  it 'should not fail with hash' do
    DataMapper.setup(
      :default,
      :adapter => 'mongo',
      :hosts => [['a.example.net',27017],['b.example.net']],
      :database => 'test-database',
      :user => 'testuser',
      :password => 'testpasswd'
    )
    DataMapper.repository(:default).adapter.send(:connection)
  end
end
