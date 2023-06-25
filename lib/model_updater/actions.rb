module ModelUpdater
  class Actions
    class << self
      def all
        con = ModelUpdater::FileLib.read(Rails.root.join(ModelUpdater.configuration.actions_file_path))
        YAML.safe_load(con)
      end

      def create action
        actions = all.push(action)
        path = Rails.root.join(ModelUpdater.configuration.actions_file_path)
        ModelUpdater::FileLib.write(path, actions.to_yaml)
      end

      def remove action
        actions = all.push(action)
        path = Rails.root.join(ModelUpdater.configuration.actions_file_path)
        ModelUpdater::FileLib.write(path, actions.to_yaml)
      end
    end
  end

  class Action
    attr_accessor :id, :user, :created_at, :model_id, :model_name, :changes, :type

    def initialize
      @id = SecureRandom.uuid
      @created_at = Time.now.utc
    end

    def save
      ModelUpdater::Actions.create self
    end
  end
end
