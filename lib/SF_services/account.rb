module SFService
  class Account < Base
    def initialize(config)
      super("Account", config)
    end

    def find_account_id_by_email(email)
      results = salesforce.query("select Id from Account where PersonEmail = '#{email}'")
      results.any? ? results.first['Account__c'] : nil
    end
  end
end
