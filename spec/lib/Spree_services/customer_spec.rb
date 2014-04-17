require 'spec_helper'

describe SpreeService::Customer do
  include_examples 'config hash'
  let(:payload) { Hash.new }
  subject { described_class.new(payload, config) }
  its(:service_name) { should == "customer" }
end
