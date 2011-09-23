module ConnectionManagement
  def with_connection
    before :all do
      setup_connection
    end
    yield
    after :all do
      teardown_connection
    end
  end
end
