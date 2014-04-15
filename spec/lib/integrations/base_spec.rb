require 'spec_helper'

describe Integration::Base do
  include_examples 'config hash'
  subject { described_class.new(config) }
  it { should respond_to(:config) }

  describe 'SF services' do

    describe "#contact_service" do
      it "returns a SF contact service instance" do
        expect(subject.send(:contact_service)).to be_a SFService::Contact
      end
    end

    describe "#product_service" do
      it "returns a SF product service instance" do
        expect(subject.send(:product_service)).to be_a SFService::Product
      end
    end

    describe "#account_service" do
      it "returns a SF account service instance" do
        expect(subject.send(:account_service)).to be_a SFService::Account
      end
    end

    describe "#order_service" do
      it "returns a SF order service instance" do
        expect(subject.send(:order_service)).to be_a SFService::Order
      end
    end
  end
end
