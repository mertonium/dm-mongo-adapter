require 'spec_helper'

describe 'replica set connections' do
  with_running_replica_set do
    let(:repo_name) { :replica_set_connection }

    it 'should connect the replica set' do
      DataMapper.setup(
        repo_name,
        :adapter => 'mongo',
        :seeds => replica_set
      )
      connection = DataMapper.repository(repo_name).adapter.send(:connection)
      connection.should be_kind_of(Mongo::ReplSetConnection)
    end

    after do
      teardown_connection repo_name
    end
  end
end
