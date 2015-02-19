require 'spec_helper'

describe SFService::Contact do
  include_examples 'config hash'
  subject { described_class.new(config) }

  describe '#model_name' do
    subject { super().model_name }
    it { should eq 'Contact' }
  end

  describe '#upsert!' do
    context "when contact doesnt exist" do
      before do
        allow(subject).to receive(:find_id_by_email).and_return(nil)
        allow(subject.send(:salesforce)).to receive(:create!).and_return(true)
      end

      it 'creates it' do
        expect(subject.send(:salesforce)).to receive(:create!).once
        subject.upsert!('test@test.com', {firstName: 'Tester'})
      end
    end

    context "when contact exists" do
      before do
        allow(subject).to receive(:find_id_by_email).and_return('123')
        allow(subject.send(:salesforce)).to receive(:update!).and_return(true)
      end

      it 'updates it' do
        expect(subject.send(:salesforce)).to receive(:update!).once
        subject.upsert!('test@test.com', {firstName: 'Tester'})
      end
    end
  end
end
