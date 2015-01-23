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
  #
  # About Salesforce Object Query Language (SOQL):
  #
  #   http://www.salesforce.com/us/developer/docs/soql_sosl/index.htm
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
        @salesforce ||= Restforce.new user_credentials.merge(app_credentials)
      end

      def user_credentials
        if config[:salesforce_instance_url].present?
          oauth_params
        else
          user_passwd_params
        end
      end

      def app_credentials
        {
          client_id: ENV['SALESFORCE_CLIENT_ID'],
          client_secret: ENV['SALESFORCE_CLIENT_SECRET']
        }
      end

      def oauth_params
        initial = {
          instance_url: config[:salesforce_instance_url],
          oauth_token: config[:salesforce_access_token]
        }

        if config[:salesforce_refresh_token].present?
          initial.merge refresh_token: config[:salesforce_refresh_token]
        else
          initial
        end
      end

      def user_passwd_params
        {
          username: config[:salesforce_username],
          password: config[:salesforce_password],
          security_token: config[:salesforce_security_token],
        }
      end
  end
end
