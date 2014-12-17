require 'spec_helper'

describe Integration::Product do
  include_examples 'config hash'

  describe "#upsert!" do
    include_examples 'product payload hash'

    subject { described_class.new(config, payload) }

    it "grabs last timestamp and return in iso8601" do
      products = [
        { "LastModifiedDate" => "2014-09-21 T21:44:32.000+0000" },
        { "LastModifiedDate" => "2014-10-21 T01:44:32.000+0000" },
        { "LastModifiedDate" => "2014-10-21 T21:43:32.000+0000" },
      ]

      expect(subject.latest_timestamp_update products).to eq "2014-10-21T21:43:32Z"
      expect(subject.latest_timestamp_update []).to be_present
    end
  end
end
