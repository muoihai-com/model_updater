namespace :model_updater do
  desc "Generate config file for ModelUpdater"
  task :install do
    initializer_file = Rails.root.join("config", "initializers", "model_updater.rb")
    content = <<~DOC
      # This is an example initializer for model_updater

      ModelUpdater.setup do |config|
        config.valid_models = %w[]
      end
    DOC
    File.write(initializer_file, content)
  end
end
