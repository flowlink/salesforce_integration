module SpreeService
  class Order < Base

    def initialize(payload, config)
      super("Order__c", payload, config)
    end
  end
end
