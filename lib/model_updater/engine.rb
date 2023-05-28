module ModelUpdater
  mattr_accessor :current_user_sym, :valid_methods, :valid_models

  self.current_user_sym = :current_user
  self.valid_methods = %i[find_by column_names]
  self.valid_models = %w[User]

  def self.setup
    yield(self)
  end

  class Engine < ::Rails::Engine
    isolate_namespace ModelUpdater
  end

  class Diploma
    class << self
      def models
        ::ApplicationRecord.descendants.map(&:name) & ModelUpdater.valid_models
      end

      def model(name)
        klass = Object.const_get(name)
        raise ModelUpdater::InvalidModel, 'Invalid model' unless ModelUpdater.valid_models.include?(klass.name)

        klass
      end
    end
  end

  class Proxy
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def column_names
      klass.column_names
    end

    def method_missing method, *args, &block
      return super unless ModelUpdater.valid_methods.include?(method)

      klass.try(method, *args, &block)
    end
  end

  class InvalidModel < StandardError; end
end
