require 'sinatra'
require 'endpoint_base'
require 'salesforce_integration'

class SalesforceEndpoint < EndpointBase::Sinatra::Base
  endpoint_key App.endpoint_key
  enable :logging

  def report_error(error)
    return unless App.env == 'production'
    logger.info request
    logger.info @payload
    Rollbar.report_exception(error)
  end

  ['/add_order', '/update_order'].each do |path|
    post path do
      begin
        SalesforceIntegration::Order.new(@payload, @config).upsert_contact!
        set_summary "Successfully upserted contact for #{@payload["order"]["email"]}"
        result 200
      rescue Exception => e
        report_error(e)
        result 500
      end
    end
  end

  ['/add_customer', '/update_customer'].each do |path|
    post path do
      begin
        SalesforceIntegration::Customer.new(@payload, @config).upsert_contact!
        set_summary "Successfully upserted contact for #{@payload["customer"]["email"]}"
        result 200
      rescue Exception => e
        report_error(e)
        result 500
      end
    end
  end

  ['/add_product', '/update_product'].each do |path|
    post path do
      begin
        SalesforceIntegration::Product.new(@payload, @config).upsert_product!
        set_summary "Successfully upserted product for #{@payload["product"]["sku"]}"
        result 200
      rescue Exception => e
        report_error(e)
        result 500
      end
    end
  end
end
