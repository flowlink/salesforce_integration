require 'sinatra'
require 'endpoint_base'
require 'salesforce_integration'

class SalesforceEndpoint < EndpointBase::Sinatra::Base
  endpoint_key ENV['ENDPOINT_KEY']
  enable :logging

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
        log_exception(e)
        result 500, e.message
      end
    end
  end

  post '/add_returns' do
    begin
      SpreeService::Return.new(@payload, @config).handle_returns!
      set_summary "Returns marked in Order ##{@payload["returns"].first["order_id"]} in Salesforce"
      result 200
    rescue Exception => e
      log_exception(e)
      result 500, e.message
    end
  end

  ['/add_customer', '/update_customer'].each do |path|
    post path do
      begin
        SpreeService::Customer.new(@payload, @config).upsert_contact_with_account!
        set_summary "Contact for #{@payload["customer"]["email"]} updated (or created) in Salesforce"
        result 200
      rescue Exception => e
        log_exception(e)
        result 500, e.message
      end
    end
  end

  ['/add_product', '/update_product'].each do |path|
    post path do
      begin
        SpreeService::Product.new(@payload, @config).upsert_product!
        set_summary "Product #{@payload["product"]["id"]} updated (or created) in Salesforce"
        result 200
      rescue Exception => e
        log_exception(e)
        result 500, e.message
      end
    end
  end

  post "/get_products" do
    products = Integration::Product.new(@config, @payload).fetch_updates
    products.each { |p| add_object "product", p }

    if (count = products.count) > 0
      result 200, "Received #{count} #{"product".pluralize count} from Salesforce"
    else
      result 200
    end
  end
end
