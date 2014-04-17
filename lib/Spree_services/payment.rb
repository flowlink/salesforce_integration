module SpreeService
  class Payment < Base

    def initialize(payload, config)
      super("order", payload, config)
    end
  end
end
