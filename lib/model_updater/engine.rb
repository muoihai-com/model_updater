module ModelUpdater
  class Engine < ::Rails::Engine
    isolate_namespace ModelUpdater

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
