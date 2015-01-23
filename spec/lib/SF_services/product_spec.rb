require 'spec_helper'

describe SFService::Product do
  include_examples 'config hash'
  subject { described_class.new(config) }

  describe '#model_name' do
    subject { super().model_name }
    it { should eq 'Product2' }
  end

  describe '#upsert!' do
    pending 'creates product if it doesnt exist' do
      allow(subject).to receive(:find_id_by_code).and_return(nil)
      allow(subject.send(:salesforce)).to receive(:create!).and_return(true)

      expect(subject.send(:salesforce)).to receive(:create!).once

      subject.upsert!('T-Shirt', {ProductCode: 'T-Shirt'})
    end

    pending 'updates product if it exists' do
      allow(subject).to receive(:find_id_by_code).and_return('123')
      allow(subject.send(:salesforce)).to receive(:update!).and_return(true)

      expect(subject.send(:salesforce)).to receive(:update!).once
      subject.upsert!('T-Shirt', {ProductCode: 'T-Shirt'})
    end
  end
end
