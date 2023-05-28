# ModelUpdater
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "model_updater", git: "https://github.com/muoihai-com/model_updater.git"
```

And then execute:
```bash
$ bundle install
```

Run the following code to create the config file:

```bash
rake model_updater:install # It will create file config/initializers/model_updater.rb
```

Add the following to your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount ModelUpdater::Engine => "/updater" unless Rails.env.production?
  ...
end
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
