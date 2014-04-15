require 'spec_helper'

describe Integration::ContactAccount do
  include_examples 'config hash'
  include_examples 'order payload hash'
  subject { described_class.new(config, payload['order']) }
  it { should respond_to(:config) }
  it { should respond_to(:object) }


  describe "#upsert!" do
    it "calls the upsert! method on SF contact service" do
      expect(subject.send(:contact_service)).to receive(:upsert!).once
      subject.upsert!
    end
  end
end
