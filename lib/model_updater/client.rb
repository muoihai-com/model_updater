module ModelUpdater
  class Client
    class << self
      def models
        all_models = ::ApplicationRecord.descendants.map(&:name)
        if all_models.blank?
          Rails.application.eager_load!
          all_models = ::ApplicationRecord.descendants.map(&:name)
        end
        if valid_model_names.blank?
          all_models
        else
          all_models & valid_model_names
        end
      end

      def model name
        klass = Object.const_get(name)
        if valid_model_names.present? && !valid_model_names.include?(klass.name)
          raise ModelUpdater::InvalidModelError
        end

        ModelUpdater::Proxy.new(klass)
      end

      def valid_model_names
        ModelUpdater::Cop.valid_model_names
      end
    end
  end
end
