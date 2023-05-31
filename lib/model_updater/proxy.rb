# frozen_string_literal: true

module ModelUpdater
  class Proxy
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def column_names
      klass.column_names
    end

    def respond_to_missing?(*args)
      klass.respond_to_missing?(*args)
    end

    def method_missing method, *args, &block
      klass.try(method, *args, &block)
    end
  end
end
