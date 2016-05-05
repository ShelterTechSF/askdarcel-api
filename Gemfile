source 'https://rubygems.org'

# Rails/Framework
gem 'actionmailer', '~> 4.2'
gem 'activerecord', '~> 4.2'
gem 'activesupport', '~> 4.2'
gem 'railties', '~> 4.2'
gem 'rails-api', '0.4.0'
gem 'devise','4.0.0'
gem 'devise_token_auth', '0.1.37'
gem 'omniauth','1.3.1'

# Persistence
gem 'pg', '~> 0.15'

# Use Unicorn as the app server
# gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker', '~> 1.6'
  gem 'rspec-rails', '~> 3.4'
  gem 'spring'
end

group :development do
  gem 'rubocop', '~> 0.38.0', require: false
end

group :test do
  gem 'rspec-collection_matchers', '~> 1.1'
end
