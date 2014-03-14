module SalesforceIntegration
  module Service
    class Base
      attr_reader :salesforce, :config, :model_name

      def initialize(model_name, config)
        @model_name = model_name
        @config = config
        @salesforce = get_client
      end

      def create!(attributes = {})
        salesforce.create!(model_name, attributes)
      end

      private
      def get_client
        Restforce.new(
          username: config['salesforce.username'],
          password: config['salesforce.password'],
          security_token: config['salesforce.security_token'],
          client_id: config['salesforce.client_id'],
          client_secret: config['salesforce.client_secret']
        )
      end
    end
  end
end
