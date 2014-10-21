require 'spec_helper'

describe Integration::Builder::Order do
  let(:payload) { Factories.add_order_payload }
  subject { described_class.new(payload['order']) }

  describe '#build' do
    let(:result) { subject.build }

    it 'returns hash with address data' do
      expect(result).to be_kind_of Hash
      expect(result.keys).to eq(
        ["AccountId", "Amount", "CloseDate", "HasOpportunityLineItem", "Name", "Pricebook2Id", "StageName", "CurrencyIsoCode"]
      )
    end
  end
end
