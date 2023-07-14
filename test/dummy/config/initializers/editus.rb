Editus.configure do |config|
  config.models = ["User", {name: "Admin", fields: %w[name], exclude_fields: %w[id]}]
end
