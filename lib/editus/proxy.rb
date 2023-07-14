module Editus
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

    def try *args
      klass.try(*args)
    end

    private

    def proxied_columns
      info = Editus::Cop.instance.info(klass)
      all = cols
      exclude_fields = info[:exclude_fields] || []
      fields = info[:fields].present? ? (all & info[:fields]) : all

      fields - %w[id] - exclude_fields
    end

    def method_missing method, *args, &block
      klass.try(method, *args, &block)
    end

    def respond_to_missing? *args
      klass.send(:respond_to_missing?, *args)
    end

    def cols
      klass.column_names
    end
  end

  class RecordProxy < Proxy
    def update_columns attributes
      update_fields = attributes.keys
      raise Editus::UpdateFieldError if (update_fields - proxied_columns).present?

      klass.update_columns attributes
    end

    def type_of_col column
      klass.class.columns_hash[column.to_s]&.type
    end

    private

    def cols
      klass.class.column_names
    end
  end
end
