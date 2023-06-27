module ModelUpdater
  class Proxy
    attr_reader :klass

    def initialize klass
      @klass = klass
    end

    def column_names
      unproxied_columns
    end

    def update_columns attributes; end

    private

    def unproxied_columns
      info = ModelUpdater::Cop.instance.info(klass)
      all = klass.column_names
      exclude_fields = info[:exclude_fields] || []
      fields = info[:fields] ? (all & info[:fields]) : all

      fields - %w[id] - exclude_fields
    end

    def method_missing method, *args, &block
      klass.try(method, *args, &block)
    end

    def respond_to_missing? *args
      klass.send(:respond_to_missing?, *args)
    end
  end
end
