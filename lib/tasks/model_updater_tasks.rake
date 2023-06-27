namespace :model_updater do
  desc "Generate config file for ModelUpdater"
  task :install do
    initializer_file = Rails.root.join("config", "model_updater.yml")
    content = YAML.dump({"models" => [], "auth" => false})
    File.write(initializer_file, content)
  end
end
