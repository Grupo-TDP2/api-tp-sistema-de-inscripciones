source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use fontawesome for common icons
gem 'font-awesome-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

gem 'mini_racer'

# JSON Web Token
gem 'jwt', '~> 2.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Use for versioning apis (api_version in routes)
gem 'versionist'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use autoprefixer to avoid writing css prefixes
gem 'autoprefixer-rails'

gem 'bootstrap-sass'

# Enables Slim templates
gem 'slim-rails'

# Rails admin
gem 'rails_admin', '~> 1.3'

# Authentication
gem 'devise'
gem 'devise-async', '~> 0.7.0'
# devise-i18n support
gem 'devise-i18n'

# CORS support
gem 'rack-cors', '~> 1.0.2', require: 'rack/cors'

# SEO Meta Tags
gem 'meta-tags'
gem 'metamagic'

gem 'active_model_serializers'

gem 'httparty', '~> 0.16'
gem 'rufus-scheduler', '~> 3.4.0'
# Sidekiq
gem 'sinatra', '>= 1.3.0', require: nil

gem 'sidekiq'
gem 'sidekiq-cron', '~> 0.6.3'
gem 'sidekiq-failures'
gem 'sidekiq_mailer'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'


group :development, :test do
  gem 'awesome_print'

  # Loads ENV variables from .env file in base folder
  gem 'dotenv-rails'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  gem 'factory_bot_rails'
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'

  # Lints
  gem 'rubocop', '0.55.0'
  gem 'rubocop-rspec', '1.25.1'

  gem 'scss_lint', require: false

  # Static analysis for security vulnerabilities
  gem 'brakeman', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-mocks'
  gem 'rspec-rails'
  gem 'shoulda-matchers'

  gem 'capybara'
  gem 'formulaic'
  gem 'launchy'

  gem 'timecop'
  gem 'webmock'

  # CodeStats
  gem 'codestats-metrics-reporter', '0.1.9', require: nil
  gem 'rubycritic', require: false
  gem 'simplecov', require: false

  # Solves 'NoMethodError: assert_template has been extracted to a gem.' as suggested by rspec
  # This error was thrown when using `expect(response).to render_template('template')`
  gem 'rails-controller-testing'

  gem 'rack-test', require: 'rack/test'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
