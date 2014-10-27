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
      results = salesforce.query("select AccountId from Contact where Email = '#{email}'")
      results.any? ? results.first['AccountId'] : nil
    end

    def upsert!(email, attributes = {})
      contact_id = find_id_by_email(email)
      contact_id.present? ? update!(attributes.merge({ Id: contact_id })) : create!(attributes)
    end

    def latest_updates(time = Time.now.utc.iso8601)
      since = time ? Time.parse(time).utc.iso8601 : Time.now.utc.iso8601

      fields = ["Contact.Id",
                "Contact.Firstname",
                "Contact.Lastname",
                "Contact.Email",
                "Contact.Account.Name",
                "Contact.LastModifiedDate"]

      filter = "LastModifiedDate > #{since} ORDER BY LastModifiedDate ASC LIMIT 100"
      salesforce.query("SELECT #{fields.join(", ")} FROM Contact WHERE #{filter}")
    end
  end
end
