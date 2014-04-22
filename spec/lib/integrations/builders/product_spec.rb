require 'spec_helper'

describe Integration::Builder::Product do
  let(:payload) { Factories.add_product_payload }
  subject { described_class.new(payload['product']) }

  describe '#build' do
    let(:result) { subject.build }

    it 'returns hash with address data' do
      expect(result).to be_kind_of Hash
      expect(result.keys).to eq(['Name', 'ProductCode', 'Description', 'Price__c', 'ExternalID__c', 'Currency__c'])
    end
  end
end
