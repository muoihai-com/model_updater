module Editus
  class Actions
    class << self
      def all
        con = Editus::FileLib.read(
          Rails.root.join(Editus.configuration.actions_file_path)
        )
        json_parse(con)
      end

      def create action
        actions = all.push(action)
        path = Rails.root.join(Editus.configuration.actions_file_path)
        Editus::FileLib.write(path, actions.to_json)
      end

      def remove action
        actions = all.push(action)
        path = Rails.root.join(Editus.configuration.actions_file_path)
        Editus::FileLib.write(path, actions.to_json)
      end

      def json_parse con
        arr = JSON.parse(con)
        arr.map do |haction|
          Action.new(**haction.symbolize_keys)
        end
      rescue StandardError
        []
      end
    end
  end

  class Action
    attr_accessor :id, :user, :created_at, :model_id, :model_name, :changes, :type

    def initialize **args
      @id = args[:id] || SecureRandom.uuid
      @created_at = args[:created_at] || Time.now.utc
      @model_id = args[:model_id]
      @model_name = args[:model_name]
      @changes = args[:changes]
      @type = args[:type]
      @user = args[:user]
    end

    def save
      Editus::Actions.create self
    end
  end
end
