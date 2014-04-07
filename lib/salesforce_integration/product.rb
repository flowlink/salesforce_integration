module SalesforceIntegration
  class Product < Base

    def upsert_product!
      product_service.upsert!(product_params['ProductCode'], product_params)
    end

    def import_products!
      product_service.import!(products_params)
    end

    def product_params(payload_item = nil)
      payload_item ||= payload['product']
      Service::ProductBuilder.new(payload_item).build
    end

    def products_params
      payload['products'].map { |item| product_params(item['product']) }
    end
  end
end
