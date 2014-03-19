module SalesforceIntegration
  class Order < Base
    def upsert_contact!
      contact_service.upsert!(customer_params['Email'], customer_params)
    end

    def customer_params
      Service::ContactBuilder.new(payload['order']).build
    end
  end
end
