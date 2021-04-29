source 'https://rubygems.org'

gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'restforce'
gem 'endpoint_base', github: 'spree/endpoint_base'
gem 'executrix'
gem 'honeybadger'
gem 'rollbar'
gem 'rake'

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'dotenv'
end

group :test do
  gem 'vcr'
  gem 'rspec', '~> 2.14'
  gem 'rack-test'
  gem 'webmock'
end

group :production do
  gem 'foreman'
  gem 'puma'
end
