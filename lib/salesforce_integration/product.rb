module SalesforceIntegration
  class Product < Base

    def upsert_product!
      product_service.upsert!(product_params['ProductCode'], product_params)
    end

    def product_params
      Service::ProductBuilder.new(payload['product']).build
    end
  end
end
