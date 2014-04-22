require 'spec_helper'

describe SFService::Base do
  include_examples 'config hash'
  subject { described_class.new('Product2', config) }
  it { should respond_to(:model_name) }
  it { should respond_to(:config) }

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
end
