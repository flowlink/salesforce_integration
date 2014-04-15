require 'spec_helper'

describe Integration::Product do
  include_examples 'config hash'

  describe "#upsert!" do
    include_examples 'product payload hash'
    subject { described_class.new(config, payload) }
    it { should respond_to(:config) }
    it { should respond_to(:object) }

    it "calls the upsert! method on SF product service" do
      expect(subject.send(:product_service)).to receive(:upsert!).once
      subject.upsert!
    end
  end

  describe "#import!" do
    include_examples 'products payload hash'
    subject { described_class.new(config, payload) }
    it { should respond_to(:config) }
    it { should respond_to(:object) }

    it "calls the import! method on SF product service" do
      expect(subject.send(:product_service)).to receive(:import!).once
      subject.import!
    end
  end
end
