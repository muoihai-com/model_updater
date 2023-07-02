# Editus
Simplify code execution and database editing. Intuitive web interface. Run code snippets, modify databases in real-time.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "editus", git: "https://github.com/muoihai-com/editus.git"
```

And then execute:
```bash
$ bundle install
```

Run the following code to create the config file:

```bash
rake editus:install # It will create file config/initializer/editus.rb
```

Add the following to your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount Editus::Engine => "/updater" unless Rails.env.production?
  ...
end
```

## Usage

### Authentication

Editus supports two forms of authentication:

  1. Define the `editus_account` method in `ApplicationHelper`: This method should return the current account (e.g., `current_user` or `current_admin`). If this method is defined, Editus will use it to determine the current account.

```ruby
  module ApplicationHelper
    def editus_account
      current_user # or any other method that returns the current account
    end
  end
 ```
    
  2. Configuration in the config/initializer/editus.rb file: Create an array containing accounts authenticated via HTTP Basic Authentication. Each account is a sub-array with two elements: the username and password.

```ruby
config.auth = [%w[user@example.com Pass@123456], %w[manager@example.com Pass@123456]]
```

Use one of the above authentication methods to secure access to Editus. Note that the `editus_account` method will take precedence if both methods are provided.

### Models

Display a simple form interface that helps you update the fields of the selected model. The update will use `update_columns` so will ignore callback and validate

### Add Script

To execute existing code create a directory `config/editus` in your code

Example:
`config/editus/update_nick_name_user.rb`

```rb
Editus::Script.define :update_nick_name_user do
  title "Update nick_name of user"
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
