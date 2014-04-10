module SalesforceIntegration
  class Order < Base
    def upsert_order!
      order_service.upsert!(order_params['Id'], order_params)
    end

    def order_params
      Service::OrderBuilder.new(payload['order']).build
    end
  end
end
