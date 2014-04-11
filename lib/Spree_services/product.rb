module SpreeService
  class Product < Base

    def initialize(payload, config)
      super("product", payload, config)
    end
  end
end
