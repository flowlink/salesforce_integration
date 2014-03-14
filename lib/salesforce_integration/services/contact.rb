module SalesforceIntegration
  module Service
    class Contact < Base
      def initialize(config)
        super("Contact", config)
      end

      def find_id_by_email(email)
        results = salesforce.query("select Id from Contact where Email = '#{email}'")
        results.any? ? results.first['Id'] : nil
      end

      def upsert!(email, attributes = {})
        contact_id = find_id_by_email(email)
        contact_id.present? ? salesforce.create!('Contact', attributes) : salesforce.update!('Contact', attributes.merge({ Id: contact_id }))
      end
    end
  end
end
