module ModelUpdater
  module HomeHelper
    def path_active? path
      request.original_url.include?(path)
    end
  end
end
