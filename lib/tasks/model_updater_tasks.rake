namespace :editus do
  desc "Generate config file for Editus"
  task :install do
    initializer_file = Rails.root.join("config", "editus.yml")
    content = YAML.dump({"models" => [], "auth" => false})
    File.write(initializer_file, content)
  end
end
