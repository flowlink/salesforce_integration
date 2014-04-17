module Integration
  class Product < Base

    attr_reader :object

    def initialize(config, object)
      @object = object.with_indifferent_access
      super(config)
    end

    def upsert!(item = nil)
      item ||= product_params
      product_service.upsert!(item['ProductCode'], item)
    end

    def import!
      product_service.import!(products_params)
    end

    def import_from_order!
      look_up('line_items').each { |item| upsert!(order_product_params(item)) }
    end

    def look_up(what)
      object[what]
    end

    private

    def product_params(payload_item = nil)
      payload_item ||= object['product']
      Integration::Builder::Product.new(payload_item).build
    end

    def products_params
      object['products'].map { |item| product_params(item) }
    end

    def order_product_params(payload_item)
      Integration::Builder::OrderProduct.new(payload_item).build
    end

    def look_up(what)
      object['order'][what]
    end

  end
end
