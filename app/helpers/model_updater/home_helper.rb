module ModelUpdater
  module HomeHelper
    def path_active? path
      request.original_url.include?(path)
    end

    def field_tag record, col, *args
      if record.try(col).is_a?(Time)
        text_field_tag(*args, placeholder: "YYYY-MM-DD HH:mm:ss UTC")
      elsif [true, false].include? record.try(col)
        safe_join [hidden_field_tag(args.first, "false", id: nil),
          check_box_tag(args.first, "true", record.try(col))]
      else
        text_field_tag(*args)
      end
    end
  end
end
