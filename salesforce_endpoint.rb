require 'sinatra'
require 'endpoint_base'

require File.expand_path(File.dirname(__FILE__) + '/lib/salesforce_integration')

class SalesforceEndpoint < EndpointBase::Sinatra::Base
  enable :logging

  post '/send_order' do
    Integration::Order.new(@config, @payload).upsert!
    result 200, "Opportunity # #{@payload["order"]["id"]} sent to Salesforce"
  end

  post '/send_return' do
    Integration::Return.new(@config, @payload).upsert!
    result 200, "Return # #{@payload[:return][:id]} updated as Note in Salesforce"
  end

  post '/send_customer' do
    Integration::ContactAccount.new(@config, @payload[:customer]).upsert!
    result 200, "Contact for #{@payload[:customer][:email]} updated in Salesforce"
  end

  post '/send_product' do
    Integration::Product.new(@config, @payload[:product]).upsert!
    set_summary "Product #{@payload["product"]["id"]} updated (or created) in Salesforce"
    result 200
  end

  post '/send_shipment' do
    begin
      Integration::Shipment.new(@config, @payload).upsert!
      result 200, "Shipment #{@payload[:shipment][:id]} updated as Note in Salesforce"
    rescue Faraday::Error::ResourceNotFound
      result 500, "Could not find Opportunity # #{@payload[:shipment][:order_id]}"
    end
  end

  post "/get_products" do
    product_service = Integration::Product.new(@config, @payload)
    products = product_service.fetch_updates
    products.each { |p| add_object "product", p }

    if (count = products.count) > 0
      add_parameter "salesforce_products_since", product_service.latest_timestamp_update
      result 200, "Received #{count} #{"product".pluralize count} from Salesforce"
    else
      result 200
    end
  end

  post "/get_customers" do
    contact_integration = Integration::ContactAccount.new(@config, @payload[:customer])
    contacts = contact_integration.fetch_updates
    add_value "customers", contacts

    if (count = contacts.count) > 0
      add_parameter "salesforce_contacts_since", contact_integration.latest_timestamp_update
      result 200, "Received #{count} #{"customer".pluralize count} from Salesforce"
    else
      result 200
    end
  end

  post "/get_orders" do
    integration = Integration::Order.new(@config)
    orders = integration.fetch_updates

    if (count = orders.count) > 0
      add_value "orders", orders
      add_parameter "salesforce_orders_since", integration.latest_timestamp_update
      result 200, "Received #{count} #{"order".pluralize count} from Salesforce"
    else
      result 200
    end
  end
end
