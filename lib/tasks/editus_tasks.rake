namespace :editus do
  desc "Generate config file for Editus"
  task :install do
    initializer_file_path = Rails.root.join(Editus::Configuration::INITIALIZER_FILE_PATH)
    content = <<~DOC
      # Editus.configure do |config|
        # config.auth = [%w[user@example.com Pass@123456], %w[manager@example.com Pass@123456]]
        # config.models = ["User", {name: "Admin", fields: %w[name], exclude_fields: %w[id]}]
        # config.actions_file_path = "tmp/editus/actions.json"
      # end
    DOC
    puts ">>> #{Editus::Configuration::INITIALIZER_FILE_PATH}"
    File.write(initializer_file_path, content)
  end
end
