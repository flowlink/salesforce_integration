module SFService
  class Account < Base
    def initialize(config)
      super("Account", config)
    end

    def find_account_id_by_email(email)
      results = salesforce.query("SELECT Contact.Account.Id FROM Contact WHERE Email = '#{email}'")
      results.any? ? results.first['Account']['Id'] : nil
    end
  end
end
