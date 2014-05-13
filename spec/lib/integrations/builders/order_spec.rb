require 'spec_helper'

describe Integration::Builder::Order do
  let(:payload) { Factories.add_order_payload }
  subject { described_class.new(payload['order']) }

  describe '#build' do
    let(:result) { subject.build }

    it 'returns hash with address data' do
      expect(result).to be_kind_of Hash
      expect(result.keys).to eq(
        ["Id__c", "Status__c", "Channel__c", "Email__c", "Currency__c", "PlacedOn__c", "Subtotal__c", "Adjustment__c", "Tax__c", "Shipping__c", "Payment__c", "Total__c"]
      )
    end
  end
end
