require 'spec_helper'

describe SalesforceEndpoint do
  include_examples 'config hash'

  context 'webhooks' do
    ['add_order', 'update_order', 'cancel_order', 'return_order',
     'add_customer', 'update_customer',
     'add_product', 'update_product', 'import_products'].each do |path|
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
            expect(body["summary"]).to match "Successfully upserted contact for #{customer_email}"
          end
        end
      end
    end
  end

  describe "upserting orders" do
    ['add_order', 'update_order', 'cancel_order', 'return_order'].each do |path|
      describe path do
        let(:payload) do
          payload = Factories.send("#{path}_payload")
          payload.merge(parameters: config)
        end
        let(:order_id){ payload["order"]["id"] }

        it 'works' do
          VCR.use_cassette "requests/#{path}" do
            post "/#{path}", payload.to_json, auth
            body = JSON.parse(last_response.body)
            expect(body["summary"]).to match "Successfully"
            expect(body["summary"]).to match "order ##{order_id}"
          end
        end
      end
    end
  end

  describe "upserting products" do
    ['add_product', 'update_product'].each do |path|
      describe path do
        let(:payload) do
          payload = Factories.send("#{path}_payload")
          payload.merge(parameters: config)
        end
        let(:product_code){ payload["product"]["sku"] }

        it 'works' do
          VCR.use_cassette "requests/#{path}" do
            post "/#{path}", payload.to_json, auth
            body = JSON.parse(last_response.body)
            expect(body["summary"]).to eq "Successfully upserted product for #{product_code}"
          end
        end
      end
    end
  end

  describe "importing products" do
    let(:payload) do
      payload = Factories.import_products_payload
      payload.merge(parameters: config)
    end

    it 'works' do
      VCR.use_cassette "requests/import_products" do
        post "/import_products", payload.to_json, auth
        body = JSON.parse(last_response.body)
        expect(body["summary"]).to eq "2/2 products successfully upserted."
      end
    end
  end
end
