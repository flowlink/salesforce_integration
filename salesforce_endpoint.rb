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
        SpreeService::Order.new(@payload, @config).upsert_contact_with_account!
        SpreeService::Order.new(@payload, @config).upsert_order!
        SpreeService::Product.new(@payload, @config).upsert_products!
        SpreeService::Order.new(@payload, @config).upsert_lineitems!
        SpreeService::Order.new(@payload, @config).upsert_payments!
        set_summary "Contact for #{@payload["order"]["email"]} and order ##{@payload["order"]["id"]} updated (or created) in Salesforce"
        result 200
      rescue Exception => e
        report_error(e)
        result 500
      end
    end
  end

  post '/add_returns' do
    begin
      SpreeService::Return.new(@payload, @config).handle_returns!
      set_summary "Returns marked in Order ##{@payload["returns"].first["inventory_units"].first["order_id"]} in Salesforce"
      result 200
    rescue Exception => e
      report_error(e)
      result 500
    end
  end

  ['/add_customer', '/update_customer'].each do |path|
    post path do
      begin
        SpreeService::Customer.new(@payload, @config).upsert_contact_with_account!
        set_summary "Contact for #{@payload["customer"]["email"]} updated (or created) in Salesforce"
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
        SpreeService::Product.new(@payload, @config).upsert_product!
        set_summary "Product #{@payload["product"]["sku"]} updated (or created) in Salesforce"
        result 200
      rescue Exception => e
        report_error(e)
        result 500
      end
    end
  end
end
