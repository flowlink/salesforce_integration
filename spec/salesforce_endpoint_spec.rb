require 'spec_helper'

describe SalesforceEndpoint do
  include_examples 'config hash'

  context 'webhooks' do
    ['add_order', 'update_order',
     'add_customer', 'update_customer',
     'add_product', 'update_product'].each do |path|
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
    ['add_order', 'update_order',
     'add_customer', 'update_customer'].each do |path|
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
end
