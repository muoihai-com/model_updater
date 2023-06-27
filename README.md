# ModelUpdater
Simplify code execution and database editing. Intuitive web interface. Run code snippets, modify databases in real-time.

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
rake model_updater:install # It will create file config/model_updater.yml
```

Add the following to your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount ModelUpdater::Engine => "/updater" unless Rails.env.production?
  ...
end
```

## Usage

### Models

Display a simple form interface that helps you update the fields of the selected model. The update will use `update_columns` so will ignore callback and validate

### Add Script

To execute existing code create a directory `config/model_updaters` in your code

Example:
`config/model_updaters/update_nick_name_user.rb`

```rb
ModelUpdater::Script.define :update_nick_name_user do
  title "Updat nick_name of user"
  task :up do
    user = User.find(1)
    nick_name = user.nick_name
    user.update_columns nick_name: "xatara"

    [1, nick_name]
  end

  task :down do |id, nick_name|
    User.find(id).update_columns(nick_name: nick_name)
  end
end

```

Make sure the filename and the defined name are the same. In the above code `title` to set the title of the code.
`task :up` is the code that will be executed when you run it.
`task :down` is the code that will be executed when you undo, if you don't need to undo you can skip it.

It can use the result returned from the `up` function to use as an input parameter

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
