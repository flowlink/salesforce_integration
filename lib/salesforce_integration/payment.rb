module SalesforceIntegration
  class Payment < Base
    def upsert_order!
      payment_service.upsert!(payment)
    end

    def order
      Service::PaymentBuilder.new(payload['payment']).build
    end
  end
end
