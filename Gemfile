source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'

gem 'mysql2'
# gem 'multi_json', '1.7.8'

# Use SCSS for stylesheets
# gem 'sass-rails', '~> 4.0.0'
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0'
gem 'uglifier'


# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem 'aws-sdk', '< 2.0'

# Used in notifications
gem 'httparty'

# gem 'npb_logging', github: 'etcetc/npb_logging'
gem 'console_candy', github: 'etcetc/console_candy'
gem 'npb_notification', github: 'etcetc/npb_notification'
gem 'enum_handler', github: 'etcetc/enum_handler'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.2'
# gem 'jbuilder'

# group :doc do
#   # bundle exec rake doc:rails generates the API under doc/api.
#   gem 'sdoc', require: false
# end


# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Push Notification servers
gem 'gcm'
gem 'apns', github: 'noplanb/APNS'

# Phone helpers
# gem 'twilio-ruby', '~> 3.12'
gem 'twilio-ruby'
gem 'global_phone'
gem 'pry-rails'
gem 'figaro'

group :development do
  gem 'better_errors'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'quiet_assets'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
end

# Testing
group :development, :test do
  gem 'pry-rescue'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'capybara'
  gem 'launchy'
  gem 'shoulda-matchers'
end
