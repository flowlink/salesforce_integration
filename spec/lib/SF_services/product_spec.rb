require 'spec_helper'

describe SFService::Product do
  include_examples 'config hash'
  subject { described_class.new(config) }
  its(:model_name) { should eq 'Product2' }

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
      subject.stub(:find_id_by_code).and_return(nil)
      subject.send(:salesforce).stub(:create!).and_return(true)

      expect(subject.send(:salesforce)).to receive(:create!).once
      subject.upsert!('T-Shirt', {ProductCode: 'T-Shirt'})
    end

    it 'updates product if it exists' do
      subject.stub(:find_id_by_code).and_return('123')
      subject.send(:salesforce).stub(:update!).and_return(true)

      expect(subject.send(:salesforce)).to receive(:update!).once
      subject.upsert!('T-Shirt', {ProductCode: 'T-Shirt'})
    end
  end
end
