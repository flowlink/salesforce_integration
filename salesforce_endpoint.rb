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
        SpreeService::Order.new(@payload, @config).upsert_order!
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
        SpreeService::Customer.new(@payload, @config).upsert_contact_with_account!
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
        SpreeService::Product.new(@payload, @config).upsert_product!
        set_summary "Successfully upserted product for #{@payload["product"]["sku"]}"
        result 200
      rescue Exception => e
        report_error(e)
        result 500
      end
    end
  end

  post '/import_products' do
    begin
      # the real @config and @payload will be provided by the HUB later
      test_config_hash = {
        'salesforce_username' => 'tester+netguru@netguru.co',
        'salesforce_password' => 'testtest123',
        'salesforce_security_token' => '98feCLrdLjqN7Ji8zhhWf3uc',
        'salesforce_client_id' => '3MVG9WtWSKUDG.x5hyqXeboVoSErlfbiCvJNDfuwmN77rRhJ6tqCeFKFhuFvMNo0COBif7CT1NnevkMq464Qp',
        'salesforce_client_secret' => '3920716088724079571'
      }.with_indifferent_access
      @config = test_config_hash
      @payload = JSON.parse IO.read("#{File.dirname(__FILE__)}/spec/support/factories/import_products.json")
      #
      batch = SpreeService::Product.new(@payload, @config).import_products!
      status = batch.status
      failed = status[:number_records_failed].to_i
      all = status[:number_records_processed].to_i
      successed = all - failed
      set_summary "#{successed}/#{all} products successfully upserted."
      result 200
    rescue Exception => e
      report_error(e)
      result 500
    end
  end
end
