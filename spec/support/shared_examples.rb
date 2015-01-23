shared_examples "config hash" do
  let(:config) do
    {
      'salesforce_instance_url'   => ENV['SALESFORCE_INSTANCE_URL'],
      'salesforce_access_token'   => ENV['SALESFORCE_ACCESS_TOKEN'],
      'salesforce_refresh_token'  => ENV['SALESFORCE_REFRESH_TOKEN']
    }.with_indifferent_access
  end
end

shared_examples "product payload hash" do
  let(:payload) { JSON.parse IO.read("#{File.dirname(__FILE__)}/factories/add_product.json") }
end

shared_examples "order payload hash" do
  let(:payload) { JSON.parse IO.read("#{File.dirname(__FILE__)}/factories/add_order.json") }
end
