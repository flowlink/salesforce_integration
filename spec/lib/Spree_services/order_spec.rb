require 'spec_helper'

describe SpreeService::Order do
  include_examples 'config hash'
  let(:payload) { Hash.new }
  subject { described_class.new(payload, config) }

  describe '#service_name' do
    subject { super().service_name }
    it { should == "order" }
  end
end
