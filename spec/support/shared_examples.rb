test_config_hash = {
  'salesforce.username' => 'tester+netguru@netguru.co',
  'salesforce.password' => 'testtest123',
  'salesforce.security_token' => '98feCLrdLjqN7Ji8zhhWf3uc',
  'salesforce.client_id' => '3MVG9WtWSKUDG.x5hyqXeboVoSErlfbiCvJNDfuwmN77rRhJ6tqCeFKFhuFvMNo0COBif7CT1NnevkMq464Qp',
  'salesforce.client_secret' => '3920716088724079571'
}.with_indifferent_access

shared_examples "config hash" do
  let(:config) { test_config_hash }
end
