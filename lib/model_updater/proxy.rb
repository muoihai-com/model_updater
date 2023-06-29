module ModelUpdater
  class Proxy
    attr_reader :klass

    def initialize klass
      @klass = klass
    end

    def column_names
      proxied_columns
    end

    def update_columns attributes; end

    def find_by *args
      record = klass.find_by(*args)
      return record if record.blank?

      RecordProxy.new(record)
    end

    private

    def proxied_columns
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

  class RecordProxy < Proxy
    def update_columns attributes
      update_fields = attributes.keys
      raise ModelUpdater::UpdateFieldError if (update_fields - proxied_columns).present?

      klass.update_columns attributes
    end
  end
end
