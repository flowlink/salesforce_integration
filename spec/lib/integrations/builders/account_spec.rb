require 'spec_helper'

describe Integration::Builder::Account do
  let(:payload) { Factories.add_customer_payload }
  subject { described_class.new(payload['customer']) }
end
