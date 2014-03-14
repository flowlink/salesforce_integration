require 'rubygems'
require 'bundler'
require 'pry'
ENV['APP_ENV'] = 'test'
Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '..', 'config/environment')
require 'salesforce_integration'
require File.join(File.dirname(__FILE__), '..', 'salesforce_endpoint')

Dir["./spec/support/**/*.rb"].each { |f| require f }

require 'spree/testing_support/controllers'

Sinatra::Base.environment = 'test'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Spree::TestingSupport::Controllers
end
