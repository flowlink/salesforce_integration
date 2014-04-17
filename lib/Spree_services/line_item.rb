module SpreeService
  class LineItem < Base

    def initialize(payload, config)
      super("order", payload, config)
    end
  end
end
