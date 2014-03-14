require 'spec_helper'

describe SalesforceIntegration::Service::Base do
  include_examples 'config hash'
  subject { described_class.new('test', config) }
  it { should respond_to(:model_name) }
  it { should respond_to(:config) }
  it { should respond_to(:salesforce) }

  context "methods" do
    describe '#create!' do
      it 'calls create! in salesforce client' do
        expect(subject.salesforce).to receive(:create!).once
        subject.create!
      end
    end
  end
end
