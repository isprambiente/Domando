source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.0.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.3'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'jsbundling-rails'
gem "cssbundling-rails"

gem 'sprockets-rails'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.12.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'letter_opener'

  gem 'capistrano', require: false
  gem 'capistrano3-puma', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-yarn', require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data' #, platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'turbo-rails', '~> 1.0.0'
gem 'stimulus-rails'
gem 'config'
gem 'active_storage_validations'
gem 'devise', '~> 4.8.0'
gem 'rack-cas'
gem 'devise_cas_authenticatable', '~> 2.0'
gem 'acts-as-taggable-on', '~> 9.0.0'
gem 'cancancan'
gem 'hamlit'
gem 'hamlit-rails'
gem 'high_voltage'
gem 'pagy'
gem 'route_translator'
gem 'pg_search', '~> 2.3', '>= 2.3.6'
