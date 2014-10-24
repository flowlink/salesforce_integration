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

    def fetch_updates
      products = product_service.latest_updates config[:salesforce_products_since]
      return [] if products.to_a.empty?

      product_ids = products.map { |p| "'#{p["Id"]}'" }.join(", ")
      prices = product_service.find_prices_by_product_ids product_ids

      products.map do |product|
        {
          id: product["ProductCode"],
          name: product["Name"],
          description: product["Description"],
          price: price_from_product_id(prices, product["Id"]),
          salesforce_id: product["Id"]
        }
      end
    end

    def import_from_order!
      look_up('line_items').each { |item| upsert!(order_product_params(with_currency(item))) }
    end

    def look_up(what)
      object[what]
    end

    def price_from_product_id(prices, product_id)
      if price = prices.find { |p| p["Product2Id"] == product_id }
        price["UnitPrice"]
      end
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
