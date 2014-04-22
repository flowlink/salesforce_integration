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

    def import_from_order!
      look_up('line_items').each { |item| upsert!(order_product_params(with_currency(item))) }
    end

    def look_up(what)
      object[what]
    end

    private

    def with_currency(item)
      item.merge({ 'Currency' => look_up('currency') })
    end

    def product_params
      Integration::Builder::Product.new(object).build
    end

    def order_product_params(payload_item)
      Integration::Builder::OrderProduct.new(payload_item).build
    end

    def look_up(what)
      object['order'][what]
    end

  end
end
