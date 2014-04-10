module SalesforceIntegration
  class Order < Base
    def upsert_order!
      order_service.upsert!(order)
    end

    def order
      Service::OrderBuilder.new(payload['order']).build
    end
  end
end
