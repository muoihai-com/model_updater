module ModelUpdater
  module HomeHelper
    def path_active? path
      request.original_url.include?(path)
    end

    def field_tag record, col, *args
      if record.try(col).is_a?(Time)
        text_field_tag(*args)
      else
        text_field_tag(*args)
      end
    end
  end
end
