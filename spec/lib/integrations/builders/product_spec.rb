require 'spec_helper'

describe Integration::Builder::Product do
  let(:payload) { Factories.add_product_payload }
  subject { described_class.new(payload['product']) }

  context 'methods' do
    describe '#build' do
      let(:method) { subject.build }

      it 'returns hash with address data' do
        expect(method).to be_kind_of Hash
        expect(method.keys.count).to eq 5
      end
    end
  end
end
