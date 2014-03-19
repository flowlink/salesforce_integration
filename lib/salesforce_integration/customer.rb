module SalesforceIntegration
  class Customer < Base
    def upsert_contact!
      contact_service.upsert!(customer_params['Email'], customer_params)
    end

    def customer_params
      Service::ContactBuilder.new(payload['customer']).build
    end
  end
end
