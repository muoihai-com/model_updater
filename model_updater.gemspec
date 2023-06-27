require_relative "lib/model_updater/version"

Gem::Specification.new do |spec|
  spec.name        = "model_updater"
  spec.version     = ModelUpdater::VERSION
  spec.authors     = ["hungkq-1724"]
  spec.email       = ["kieu.quoc.hung@sun-asterisk.com"]
  spec.homepage    = "https://github.com/muoihai-com/model_updater"
  spec.summary     = "ModelUpdater helps tester to update model easily"
  spec.description = "ModelUpdater helps tester to update model easily"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.0", "< 7.0"
  spec.add_development_dependency "rspec-rails"
end
