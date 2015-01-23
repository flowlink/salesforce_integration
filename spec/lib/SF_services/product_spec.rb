require 'spec_helper'

describe SFService::Product do
  include_examples 'config hash'
  subject { described_class.new(config) }

  describe '#model_name' do
    subject { super().model_name }
    it { should eq 'Product2' }
  end
end
