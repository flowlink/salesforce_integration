module Integration
  class Product < Base

    attr_reader :object

    def initialize(config, object)
      @object = object.with_indifferent_access
      super(config)
    end

    def upsert!
      product_service.upsert!(product_params['ProductCode'], product_params)
    end

    def import!
      product_service.import!(products_params)
    end

    private

    def product_params(payload_item = nil)
      payload_item ||= object['product']
      Integration::Builder::Product.new(payload_item).build
    end

    def products_params
      object['products'].map { |item| product_params(item['product']) }
    end

  end
end
