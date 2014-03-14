require 'spec_helper'

describe SalesforceIntegration::Service::Contact do
  include_examples 'config hash'
  subject { described_class.new(config) }

  it { expect(subject.model_name).to eq 'Contact' }

  context "methods" do
    describe '#find_id_by_email' do
      it 'returns id when contact with given email exists' do
        VCR.use_cassette 'services/contact_find_id_by_email_true' do
          expect(subject.find_id_by_email('tester@test.com')).to be_a(String)
        end
      end

      it 'returns nil if theres no contact with given email' do
        VCR.use_cassette 'services/contact_find_id_by_email_false' do
          expect(subject.find_id_by_email('not-available@test.com')).to be_nil
        end
      end
    end
  end
end
