require 'spec_helper'

describe SalesforceEndpoint do
  include_examples 'config hash'

  context 'webhooks' do
    ['add_order', 'update_order'].each do |path|
      describe path do
        let(:payload) do
          payload = Factories.send("#{path}_payload")
          payload.merge(parameters: config)
        end

        it 'works' do
          VCR.use_cassette "requests/#{path}" do
            post "/#{path}", payload.to_json, auth
            expect(last_response).to be_ok
            body = JSON.parse(last_response.body)
            expect(body["request_id"]).to eq payload["request_id"]
          end
        end
      end
    end
  end

  describe "upserting clients with accounts" do
    ['add_order', 'update_order'].each do |path|
      describe path do
        let(:payload) do
          payload = Factories.send("#{path}_payload")
          payload.merge(parameters: config)
        end
        let(:customer_email){ payload["order"].nil? ? payload["customer"]["email"] : payload["order"]["email"] }

        it 'works' do
          VCR.use_cassette "requests/#{path}" do
            post "/#{path}", payload.to_json, auth
            body = JSON.parse(last_response.body)
            expect(body["summary"]).to match "Contact for #{customer_email}"
          end
        end
      end
    end
  end

  describe "upserting orders" do
    ['add_order', 'update_order'].each do |path|
      describe path do
        let(:payload) do
          payload = Factories.send("#{path}_payload")
          payload.merge(parameters: config)
        end
        let(:customer_email) { payload["order"]["email"] }
        let(:order_id){ payload["order"]["id"] }

        it 'works' do
          VCR.use_cassette "requests/#{path}" do
            post "/#{path}", payload.to_json, auth
            body = JSON.parse(last_response.body)
            expect(body["summary"]).to eq "Contact for #{customer_email} and order ##{order_id} updated (or created) in Salesforce"
          end
        end
      end
    end
  end

  it "adds customer" do
    payload = Factories.add_customer_payload.merge(parameters: config)
    email = payload['customer']['email']

    VCR.use_cassette "requests/add_customer" do
      post "/add_customer", payload.to_json, auth
      expect(json_response["summary"]).to match "#{email} updated in Salesforce"
      expect(last_response.status).to eq 200
    end
  end

  it "updates customer" do
    payload = Factories.add_customer_payload.merge(parameters: config)
    payload['customer']['shipping_address']['phone'] = '333 333 333'
    email = payload['customer']['email']

    VCR.use_cassette "requests/update_customer" do
      post "/add_customer", payload.to_json, auth
      expect(json_response["summary"]).to match "#{email} updated in Salesforce"
      expect(last_response.status).to eq 200
    end
  end

  it 'adds product' do
    payload = Factories.add_product_payload.merge(parameters: config)
    id = payload['product']['id']

    VCR.use_cassette "requests/add_product" do
      post "/add_product", payload.to_json, auth
      expect(json_response["summary"]).to match "Product #{id}"
    end
  end

  it 'updates product' do
    payload = Factories.add_product_payload.merge(parameters: config)
    id = payload['product']['id']
    payload['product']['price'] = 101

    VCR.use_cassette "requests/update_product" do
      post "/update_product", payload.to_json, auth
      expect(json_response["summary"]).to match "Product #{id}"
    end
  end

  it "get products" do
    payload = {
      parameters: config.merge(salesforce_products_since: "2014-10-17T16:14:57-03:00")
    }

    VCR.use_cassette "requests/get_products" do
      post "/get_products", payload.to_json, auth

      expect(json_response["summary"]).to match "Received"
      expect(last_response.status).to eq 200

      expect(json_response["parameters"]).to have_key "salesforce_products_since"
      expect(json_response["products"]).to be_a Array
    end
  end

  it "empty get products result" do
    payload = {
      parameters: config.merge(salesforce_products_since: "2014-10-24T19:14:57-03:00")
    }

    VCR.use_cassette "requests/get_products_empty" do
      post "/get_products", payload.to_json, auth
      expect(json_response["summary"]).to be_nil
      expect(last_response.status).to eq 200
    end
  end
end
