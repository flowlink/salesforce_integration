require 'sinatra'
require 'endpoint_base'
require 'salesforce_integration'

class SalesforceEndpoint < EndpointBase::Sinatra::Base
  # orders webhooks
  ['/add_order', '/update_order'].each do |path|
    post path do
      begin
        SalesforceIntegration::Order.new(@payload, @config).upsert_contact!
        set_summary "Successfully upserted contact for #{@payload["order"]["email"]}"
        process_result 200
      rescue StandardError => e
       process_result 500
      end
    end
  end

  # customer webhooks
  ['/add_customer', '/update_customer'].each do |path|
    post path do
      begin
        SalesforceIntegration::Customer.new(@payload, @config).upsert_contact!
        set_summary "Successfully upserted contact for #{@payload["order"]["email"]}"
        process_result 200
      rescue StandardError => e
       process_result 500
      end
    end
  end
end
