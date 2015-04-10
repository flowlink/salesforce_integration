module SFService
  class Account < Base
    def initialize(config)
      super("Account", config)
    end

    def find_account_id_by_email(email)
      results = salesforce.query("SELECT Contact.Account.Id FROM Contact WHERE Email = '#{email}'")
      results.any? ? results.first['Account']['Id'] : nil
    end

    def fetch_contacts_along(ids)
      fields = ["Account.Id",
                "Account.BillingCity",
                "Account.BillingCountry",
                "Account.BillingPostalCode",
                "Account.BillingState",
                "Account.BillingStreet",
                "Account.Name",
                "Account.Phone",
                "Account.ShippingCity",
                "Account.ShippingCountry",
                "Account.ShippingPostalCode",
                "Account.ShippingState",
                "Account.ShippingStreet"].join(", ")

      contacts = "SELECT FirstName, LastName, Email FROM Contacts"
      filter = "Id IN (#{ids.join(", ")})"

      salesforce.query("SELECT #{fields}, (#{contacts}) FROM Account WHERE #{filter}")
    end
  end
end
