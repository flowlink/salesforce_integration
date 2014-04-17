module SpreeService
  class Customer < Base

    def initialize(payload, config)
      super("customer", payload, config)
    end
  end
end
