require 'spec_helper'

describe SalesforceEndpoint do
  include_examples 'config hash'

  context "orders" do
    let(:payload) do
      payload = Factories.send("add_order_payload")
      payload.merge(parameters: config)
    end

    it "adds" do
      VCR.use_cassette "requests/add_order" do
        post "/add_order", payload.to_json, auth

        expect(json_response["summary"]).to match "sent to Salesforce"
        expect(last_response.status).to eq 200
      end
    end
  end

  context "returns" do
    let(:payload) do
      payload = Factories.send("add_returns_payload")
      payload.merge(parameters: config)
    end

    it "adds" do
      VCR.use_cassette "requests/add_returns" do
        post "/add_returns", payload.to_json, auth

        expect(json_response["summary"]).to match "Returns marked in Order"
        expect(last_response.status).to eq 200
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
      expect(last_response.status).to eq 200
    end
  end

  it 'updates product' do
    payload = Factories.add_product_payload.merge(parameters: config)
    id = payload['product']['id']
    payload['product']['price'] = 101

    VCR.use_cassette "requests/update_product" do
      post "/update_product", payload.to_json, auth
      expect(json_response["summary"]).to match "Product #{id}"
      expect(last_response.status).to eq 200
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
      parameters: config.merge(salesforce_products_since: "2014-10-28T19:14:57-03:00")
    }

    VCR.use_cassette "requests/get_products_empty" do
      post "/get_products", payload.to_json, auth
      expect(json_response["summary"]).to be_nil
      expect(last_response.status).to eq 200
    end
  end

  it "get customers" do
    payload = {
      parameters: config.merge(salesforce_contacts_since: "2014-10-25T18:06:36-03:00")
    }

    VCR.use_cassette "requests/get_customers" do
      post "/get_customers", payload.to_json, auth

      expect(json_response["summary"]).to match "Received"
      expect(last_response.status).to eq 200

      expect(json_response["parameters"]).to have_key "salesforce_contacts_since"
      expect(json_response["customers"]).to be_a Array
    end
  end
end
