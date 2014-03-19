require 'spec_helper'

describe SalesforceEndpoint do
  include_examples 'config hash'

  context 'order webhooks' do
    describe '/add_order' do
      let(:payload) do
        payload = Factories.add_order_payload
        payload.merge(parameters: config)
      end

      it 'works' do
        VCR.use_cassette 'requests/add_order' do
          post '/add_order', payload.to_json, auth
          expect(last_response).to be_ok
          body = JSON.parse(last_response.body)
          expect(body["request_id"]).to eq payload["request_id"]
          expect(body["summary"]).to eq "Successfully upserted contact for #{payload["order"]["email"]}"
        end
      end
    end
  end
end
