module SpreeService
  class Return < Base

    def initialize(payload, config)
      super("returns", payload, config)
    end
  end
end
