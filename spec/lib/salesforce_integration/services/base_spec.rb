require 'spec_helper'

describe SalesforceIntegration::Service::Base do
  include_examples 'config hash'
  subject { described_class.new('Product2', config) }
  it { should respond_to(:model_name) }
  it { should respond_to(:config) }

  context "methods" do
    describe '#create!' do
      it 'calls create! in salesforce client' do
        expect(subject.send(:salesforce)).to receive(:create!).once
        subject.create!
      end
    end

    describe '#update!' do
      it 'calls update! in salesforce client' do
        expect(subject.send(:salesforce)).to receive(:update!).once
        subject.update!
      end
    end

    describe '#import!' do
      let(:models) { Factories.models_to_import_payload }

      it 'calls upsert in salesforce bulk client' do
        expect(subject.send(:salesforce_bulk)).to receive(:upsert).once
        subject.import!(models)
      end
    end
  end
end
