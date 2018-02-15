source 'https://rubygems.org'

# Rails/Framework
gem 'rails', '~> 5.0.0'
gem 'jsonite', '0.0.3'
gem 'geokit-rails'

# Persistence
gem 'pg', '~> 0.15'

# Auth
gem 'devise_token_auth'
gem 'omniauth'

# Use Puma as the app server
gem 'puma'

gem 'phonelib'
gem 'faker', '~> 1.6'

# Search Provider
gem 'algoliasearch-rails', '~> 1.19.1'

# CORS
gem 'rack-cors'

group :production do
  gem 'activerecord-nulldb-adapter'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug'
  gem 'bullet'
  gem 'factory_girl_rails', '~> 4.7'
  gem 'rspec-rails', '~> 3.4'
  gem 'spring'
  gem 'rubocop', '~> 0.52.1', require: false
end

group :test do
  gem 'rspec-collection_matchers', '~> 1.1'
end
