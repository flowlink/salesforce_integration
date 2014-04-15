require 'spec_helper'

describe Integration::Builder::Account do
  let(:payload) { Factories.add_customer_payload }
  subject { described_class.new(payload['customer']) }

  describe '#build' do
    let(:result) { subject.build }

    it 'returns hash with address data' do
      expect(result).to be_kind_of Hash
      expect(result.keys).to eq(
        ["Name"]
      )
    end
  end
end
