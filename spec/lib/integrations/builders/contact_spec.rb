require 'spec_helper'

describe Integration::Builder::Contact do

  context "when creating contact params from order payload" do
    let(:payload) { Factories.new_order_payload }
    subject { described_class.new(payload['order']) }

    describe '#build' do
      let(:result) { subject.build }

      it 'returns hash with address data' do
        expect(result).to be_kind_of Hash
        expect(result.keys).to eq(
          ["FirstName", "LastName", "Email",
            "MailingStreet", "MailingCity", "MailingState", "MailingPostalCode", "MailingCountry",
            "OtherStreet", "OtherCity", "OtherState", "OtherPostalCode", "OtherCountry",
            "Phone", "OtherPhone"]
        )
      end
    end
  end

  context "when creating contact params from customer payload" do
    let(:payload) { Factories.add_customer_payload }
    subject { described_class.new(payload['customer']) }

    describe '#build' do
      let(:result) { subject.build }

      it 'returns hash with address data' do
        expect(result).to be_kind_of Hash
        expect(result.keys).to eq(
          ["FirstName", "LastName", "Email",
            "MailingStreet", "MailingCity", "MailingState", "MailingPostalCode", "MailingCountry",
            "OtherStreet", "OtherCity", "OtherState", "OtherPostalCode", "OtherCountry",
            "Phone", "OtherPhone"]
        )
      end
    end
  end
end
