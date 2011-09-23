module DataMapper::Mongo::Spec
  module ConnectionManagement
    def with_connection
      before :all do
        ensure_connection 
      end
      yield
    end
  end
end
