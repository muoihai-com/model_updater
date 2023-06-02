# frozen_string_literal: true

module ModelUpdater
  class Proxy
    attr_reader :klass

    def initialize klass
      @klass = klass
    end

    delegate :column_names, to: :klass

    def method_missing method, *args, &block
      klass.try(method, *args, &block)
    end

    private

    def respond_to_missing? *args
      klass.send(:respond_to_missing?, *args)
    end
  end
end
