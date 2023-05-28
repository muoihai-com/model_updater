namespace :model_updater do
  desc 'Generate config file for ModelUpdater'
  task :install do
    initializer_file = File.join(Rails.root, 'config', 'initializers', 'model_updater.rb')
    content = <<~DOC
      # This is an example initializer for model_updater

      ModelUpdater.setup do |config|
        config.current_user_sym = :current_user
        config.valid_methods = %i[find_by]
        config.valid_models = %w[User]
      end
    DOC
    File.write(initializer_file, content)
  end
end
