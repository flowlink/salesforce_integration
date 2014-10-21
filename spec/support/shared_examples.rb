test_config_hash = {
  'salesforce_username'       => ENV['SALESFORCE_USERNAME'],
  'salesforce_password'       => ENV['SALESFORCE_PASSWORD'],
  'salesforce_security_token' => ENV['SALESFORCE_SECURITY_TOKEN'],
  'salesforce_client_id'      => ENV['SALESFORCE_CLIENT_ID'],
  'salesforce_client_secret'  => ENV['SALESFORCE_CLIENT_SECRET']
}.with_indifferent_access

shared_examples "config hash" do
  let(:config) { test_config_hash }
end

shared_examples "product payload hash" do
  let(:payload) { JSON.parse IO.read("#{File.dirname(__FILE__)}/factories/add_product.json") }
end

shared_examples "order payload hash" do
  let(:payload) { JSON.parse IO.read("#{File.dirname(__FILE__)}/factories/add_order.json") }
end
