module SFService
  class Base
    attr_reader :salesforce, :salesforce_bulk, :config, :model_name

    def initialize(model_name, config)
      @model_name = model_name
      @config = config
    end

    def create!(attributes = {})
      salesforce.create!(model_name, attributes)
    end

    def update!(attributes = {})
      salesforce.update!(model_name, attributes)
    end

    def import!(models, external_id = 'ExternalId__c')
      salesforce_bulk.upsert(model_name, models, external_id)
    end

    private

    def salesforce
      @salesforce ||= Restforce.new(
        username: config['salesforce_username'],
        password: config['salesforce_password'],
        security_token: config['salesforce_security_token'],
        client_id: config['salesforce_client_id'],
        client_secret: config['salesforce_client_secret']
      )
    end

    def salesforce_bulk
      @salesforce_bulk ||= Executrix::Api.new(
        config['salesforce_username'],
        config['salesforce_password'] + config['salesforce_security_token']
      )
    end
  end
end
