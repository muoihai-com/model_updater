module ModelUpdater
  class Client
    class << self
      def models
        valid_models = ModelUpdater.configuration.valid_models
        if valid_models.blank?
          ::ApplicationRecord.descendants.map(&:name)
        else
          ::ApplicationRecord.descendants.map(&:name) & valid_models
        end
      end

      def model name
        klass = Object.const_get(name)
        valid_models = ModelUpdater.configuration.valid_models
        if valid_models.present? && !ModelUpdater.configuration.valid_models.include?(klass.name)
          raise
        end

        ModelUpdater::Proxy.new(klass)
      end
    end
  end
end
