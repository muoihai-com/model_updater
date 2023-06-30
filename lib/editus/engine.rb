module Editus
  class Engine < ::Rails::Engine
    isolate_namespace Editus

    config.generators do |g|
      g.test_framework :rspec
    end

    config.after_initialize do
      Editus.load_file_config
      Editus.find_definitions
    end
  end
end
