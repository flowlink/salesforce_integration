module SalesforceIntegration
  module Service
    class Order < Base

      def initialize(config)
        super("Order__c", config)
      end

      def find_id_by_email(email)
        results = salesforce.query("select Id from Order__c where Email__c = '#{email}'")
        results.any? ? results.first['Id'] : nil
      end

      def upsert!(email, attributes = {})
        contact_id = find_id_by_email(email)
        contact_id.present? ? update!(attributes.merge({ Id: contact_id })) : create!(attributes)
      end

    end
  end
end
