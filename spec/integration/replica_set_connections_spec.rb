require 'spec_helper'

describe 'replica set connections' do
  with_running_replica_set do
    it 'should connect the replica set' do
      DataMapper.setup(
        :replica_set_connection,
        :adapter => 'mongo',
        :seeds => replica_set
      )
      connection = DataMapper.repository(:default).adapter.send(:connection)
      connection.should be_kind_of(Mongo::ReplSetConnection)
    end

    after do
      teardown_connection :replica_set_connection
    end
  end
end
