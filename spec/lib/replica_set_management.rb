module DataMapper::Mongo::Spec
  module ReplicaSetManagement
    def with_running_replica_set
      before :all do
        @replica_set = start_replica_set
      end
   
      let(:replica_set) { @replica_set }
   
      yield
   
      after :all do
        teardown_replica_set
      end
    end
  end
end
