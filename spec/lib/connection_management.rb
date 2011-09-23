module ConnectionManagement
  def with_connection
    if ENV['MONGO_URL'] or ENV['TRAVIS']
      before :all do
        setup_connection
      end
      yield
      after :all do
        teardown_connection
      end
    end
  end
end
