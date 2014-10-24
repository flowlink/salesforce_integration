module SFService
  # Note about `query` methods: 
  #
  #   http://www.salesforce.com/us/developer/docs/api_rest/Content/resources_query.htm
  #
  #   If the query results are too large, the response contains the first batch
  #   of results and a query identifier in the nextRecordsUrl field of the
  #   response. The identifier can be used in an additional request to retrieve
  #   the next batch.
  #
  class Base
    attr_reader :salesforce, :config, :model_name

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
  end
end
