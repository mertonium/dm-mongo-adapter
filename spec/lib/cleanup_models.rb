module DataMapper::Mongo::Spec
  module CleanupModels

    # Cleans up models after a spec by dropping the Mongo collection,
    # removing the model classes from the descendants list, and then
    # undefining the constants.
    #
    # @todo Only used once; try to remove.
    #
    def cleanup_models(*models)
      unless models.empty?
        model = models.pop
        name = model.name

        if model.respond_to?(:storage_name)
          db = DataMapper::Mongo::Spec.database(model.repository.name)
          db.drop_collection(model.storage_name)
        end

        DataMapper::Model.descendants.delete(model)

        if name && Object.const_defined?(name)
          Object.send(:remove_const, name)
        end

        cleanup_models(*models)
      end
    end

  end # CleanupModels
end # DataMaper::Mongo::Spec
