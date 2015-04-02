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

    it 'doesnt fail on nil address' do
      payload['customer']['billing_address']['address1'] = nil
      payload['customer']['billing_address']['address2'] = nil
      subject = described_class.new payload['customer']
      expect(subject.build['OtherStreet']).to eq ''
    end

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
