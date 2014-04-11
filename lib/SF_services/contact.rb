module SFService
  class Contact < Base

    def initialize(config)
      super("Contact", config)
    end

    def find_id_by_email(email)
      results = salesforce.query("select Id from Contact where Email = '#{email}'")
      results.any? ? results.first['Id'] : nil
    end

    def find_account_id_by_email(email)
      results = salesforce.query("select Account__c from Contact where Email = '#{email}'")
      results.any? ? results.first['Account__c'] : nil
    end

    def upsert!(email, attributes = {})
      contact_id = find_id_by_email(email)
      contact_id.present? ? update!(attributes.merge({ Id: contact_id })) : create!(attributes)
    end
  end
end
