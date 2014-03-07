require 'sinatra'
require 'endpoint_base'

class SalesforceEndpoint < EndpointBase::Sinatra::Base
  get '/test' do
    process_result 200
  end
end
