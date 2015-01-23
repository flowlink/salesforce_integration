require 'rubygems'
require 'bundler'

Bundler.require(:default)
require './salesforce_endpoint.rb'

run SalesforceEndpoint
