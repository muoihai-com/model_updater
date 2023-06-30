require_relative "lib/editus/version"

Gem::Specification.new do |spec|
  spec.name        = "editus"
  spec.version     = Editus::VERSION
  spec.authors     = ["hungkieu"]
  spec.email       = ["hungkieu.h12@gmail.com"]
  spec.homepage    = "https://github.com/muoihai-com/editus"
  spec.summary     = Editus::SUMMARY
  spec.description = Editus::DESCRIPTION
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.0", "< 7.0"
  spec.add_development_dependency "rspec-rails"
end
