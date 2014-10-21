require 'spec_helper'

describe SFService::Product do
  include_examples 'config hash'
  subject { described_class.new(config) }

  describe '#model_name' do
    subject { super().model_name }
    it { should eq 'Product2' }
  end

  describe '#find_id_by_code' do
    it 'returns id when product with given code exists' do
      VCR.use_cassette 'services/product_find_id_by_code_true' do
        expect(subject.find_id_by_code('SPREE-T-SHIRT-S')).to be_a(String)
      end
    end

    it 'returns nil if theres no product with given code' do
      VCR.use_cassette 'services/product_find_id_by_code_false' do
        expect(subject.find_id_by_code('something')).to be_nil
      end
    end
  end

  describe '#upsert!' do
    it 'creates product if it doesnt exist' do
      allow(subject).to receive(:find_id_by_code).and_return(nil)
      allow(subject.send(:salesforce)).to receive(:create!).and_return(true)

      expect(subject.send(:salesforce)).to receive(:create!).once
      subject.upsert!('T-Shirt', {ProductCode: 'T-Shirt'})
    end

    it 'updates product if it exists' do
      allow(subject).to receive(:find_id_by_code).and_return('123')
      allow(subject.send(:salesforce)).to receive(:update!).and_return(true)

      expect(subject.send(:salesforce)).to receive(:update!).once
      subject.upsert!('T-Shirt', {ProductCode: 'T-Shirt'})
    end
  end
end
