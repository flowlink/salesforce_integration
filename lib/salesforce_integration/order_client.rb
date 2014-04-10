module SalesforceIntegration
  class OrderClient < Base

    def upsert_order!
      contact_service.upsert!(customer.fetch('Email'), customer)
    end

    def order_client_builder
      Service::OrderClientBuilder.new(payload['order']).build
    end

    def customer
      Service::ContactBuilder.new(order_client_builder).build
    end

  end
end
