require 'spec_helper'

describe Integration::Builder::Account do
  let(:payload) { Factories.add_customer_payload }
  subject { described_class.new(payload['customer']) }

  describe '#build' do
    let(:default_expected) do
      [
        "ShippingStreet", "ShippingCity", "ShippingState", "ShippingPostalCode",
        "ShippingCountry", "BillingStreet", "BillingCity", "BillingState",
        "BillingPostalCode", "BillingCountry", "Name", "AccountNumber",
        "channel__c"
      ]
    end

    it 'returns hash with address data' do
      expect(subject.build).to be_kind_of Hash
      expect(subject.build.keys).to match_array default_expected
    end

    it 'append record type id and name fields for person accounts' do
      payload['customer']['sf_record_type_id'] = 123
      subject = described_class.new payload['customer']

      default_expected.delete 'Name'
      expected = default_expected.push ["RecordTypeId", "FirstName", "LastName"]
      expect(subject.build.keys).to match_array expected.flatten
    end
  end
end
