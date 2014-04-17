module Integration
  class Order < Base

    attr_reader :object

    def initialize(config, object)
      @object = object.with_indifferent_access
      super(config)
    end

    def upsert!
      order_service.upsert!(order_params)
    end

    private

    def order_params
      Integration::Builder::Order.new(object['order']).build
    end

  end
end
