module SpreeService
  class Order < Base

    def initialize(payload, config)
      super("order", payload, config)
    end
  end
end
