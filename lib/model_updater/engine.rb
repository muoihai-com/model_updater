module ModelUpdater
  class Engine < ::Rails::Engine
    isolate_namespace ModelUpdater

    config.generators do |g|
      g.test_framework :rspec
    end

    config.after_initialize do
      ModelUpdater.load_file_config
      ModelUpdater.find_definitions
    end
  end
end
