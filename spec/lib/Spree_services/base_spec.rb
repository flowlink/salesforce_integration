require 'spec_helper'

describe SpreeService::Base do
  include_examples 'config hash'
  include_examples 'product payload hash'
  subject { described_class.new('product', payload, config) }
  it { should respond_to(:service_name) }
  it { should respond_to(:payload) }
  it { should respond_to(:config) }

  context "methods" do
    describe '#upsert_contact_with_account!' do
      it 'creates a contact-account integration and calls upsert! on it' do
        expect_any_instance_of(Integration::ContactAccount).to receive(:upsert!).once
        subject.upsert_contact_with_account!
      end
    end

    describe '#upsert_order!' do
      it 'creates an order-account integration and calls upsert! on it' do
        expect_any_instance_of(Integration::Order).to receive(:upsert!).once
        subject.upsert_order!
      end
    end

    describe '#upsert_product!' do
      it 'creates an product integration and calls upsert! on it' do
        expect_any_instance_of(Integration::Product).to receive(:upsert!).once
        subject.upsert_product!
      end
    end
  end
end
