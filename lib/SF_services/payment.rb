module SFService
  class Payment < Base
    def initialize(config)
      super("Payment__c", config)
    end

    def upsert!(payment_attr = {})
      create!(payment_attr)
    end
  end
end
