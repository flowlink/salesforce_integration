require 'spec_helper'

describe Integration::Builder::Contact do
  let(:payload) { Factories.add_order_payload }
  subject { described_class.new(payload['order']) }

  context 'methods' do
    describe '#build' do
      let(:method) { subject.build }

      it 'returns hash with address data' do
        expect(method).to be_kind_of Hash
        expect(method.keys.count).to eq 15
      end
    end
  end
end
