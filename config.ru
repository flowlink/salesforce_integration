require 'rubygems'
require 'bundler'
Bundler.require(:default)

require './config/environment'
require "./salesforce_endpoint"
run SalesforceEndpoint
