SpreeGotomeeting
================

Introduction goes here.

## Installation

1. Add this extension to your Gemfile with this line:
  ```ruby
  gem 'spree_gotomeeting', github: '[your-github-handle]/spree_gotomeeting', branch: 'X-X-stable'
  ```

  The `branch` option is important: it must match the version of Spree you're using.
  For example, use `3-1-stable` if you're using Spree `3-1-stable` or any `3.1.x` version.

2. This gem requires the `go_to_webinar` gem, which is not published to
   rubygems. So you'll need to also add that gem to your `Gemfile`:
   ```ruby
   gem 'go_to_webinar', github: 'citrixonline/GoToWebinar-Ruby'
   ```

3. Install the gem using Bundler:
  ```ruby
  bundle install
  ```

4. Copy & run migrations
  ```ruby
  bundle exec rails g spree_gotomeeting:install
  ```

5. Restart your server

  If your server was running, restart it so that it can find the assets properly.

## Testing

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_gotomeeting/factories'
```


## Contributing

If you'd like to contribute, please take a look at the
[instructions](CONTRIBUTING.md) for installing dependencies and crafting a good
pull request.

Copyright (c) 2016 [name of extension creator], released under the New BSD License
