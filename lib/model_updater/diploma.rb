module ModelUpdater
  class Diploma
    class << self
      def models
        return ::ApplicationRecord.descendants.map(&:name) & ModelUpdater.valid_models if ModelUpdater.valid_models.any?

        ::ApplicationRecord.descendants.map(&:name)
      end

      def model(name)
        klass = Object.const_get(name)
        if ModelUpdater.valid_models.empty? || ModelUpdater.valid_models.include?(klass.name)
          return Model::Proxy.new(klass)
        end

        raise ModelUpdater::InvalidModel, 'Invalid model'
      end
    end
  end
end
