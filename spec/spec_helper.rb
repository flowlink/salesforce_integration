require 'rubygems'
require 'bundler'
require 'pry'
require 'dotenv'
Dotenv.load

ENV['APP_ENV'] = 'test'
ENV['ENDPOINT_KEY'] = '123'
Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '..', 'config/environment')
require 'salesforce_integration'
require File.join(File.dirname(__FILE__), '..', 'salesforce_endpoint')

Dir["./spec/support/**/*.rb"].each &method(:require)

require 'spree/testing_support/controllers'

Sinatra::Base.environment = 'test'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock

  c.filter_sensitive_data('spree_user')   { |_| ENV['SALESFORCE_USERNAME'] }
  c.filter_sensitive_data('spree_user')   { |_| ENV['SALESFORCE_USERNAME'].to_s.gsub('@','%40') }
  c.filter_sensitive_data('spree_pwd')    { |_| ENV['SALESFORCE_PASSWORD'] }
  c.filter_sensitive_data('spree_sec')    { |_| ENV['SALESFORCE_SECURITY_TOKEN'] }
  c.filter_sensitive_data('spree_id')     { |_| ENV['SALESFORCE_CLIENT_ID'] }
  c.filter_sensitive_data('spree_secret') { |_| ENV['SALESFORCE_CLIENT_SECRET'] }
  c.filter_sensitive_data('instance_url') { |_| ENV['SALESFORCE_INSTANCE_URL'] }
  c.filter_sensitive_data('access_token') { |_| ENV['SALESFORCE_ACCESS_TOKEN'] }
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Spree::TestingSupport::Controllers
end
