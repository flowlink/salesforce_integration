test_config_hash = {
  'salesforce_username' => 'tester+netguru@netguru.co',
  'salesforce_password' => 'testtest123',
  'salesforce_security_token' => '98feCLrdLjqN7Ji8zhhWf3uc',
  'salesforce_client_id' => '3MVG9WtWSKUDG.x5hyqXeboVoSErlfbiCvJNDfuwmN77rRhJ6tqCeFKFhuFvMNo0COBif7CT1NnevkMq464Qp',
  'salesforce_client_secret' => '3920716088724079571'
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
