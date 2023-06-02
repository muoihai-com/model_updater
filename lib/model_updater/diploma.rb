# frozen_string_literal: true

module ModelUpdater
  class Diploma
    class << self
      def models
        if ModelUpdater.valid_models.any?
          return ::ApplicationRecord.descendants.map(&:name) & ModelUpdater.valid_models
        end

        ::ApplicationRecord.descendants.map(&:name)
      end

      def model name
        klass = Object.const_get(name)
        if ModelUpdater.valid_models.empty? || ModelUpdater.valid_models.include?(klass.name)
          return ModelUpdater::Proxy.new(klass)
        end

        raise ModelUpdater::InvalidModel, "Invalid model"
      end
    end
  end
end
