module Integration
  class Product < Base

    delegate :find_id_by_code, :create!, to: :product_service
    attr_reader :object

    def initialize(config, object)
      @object = object
      super(config)
    end

    def upsert!(item = nil)
      item ||= product_params
      item.merge Id: product_id if product_id = find_id_by_code(product_code)
      product_service.upsert! item
    end

    def fetch_updates
      return [] if latest_products.to_a.empty?

      product_ids = latest_products.map { |p| "'#{p["Id"]}'" }.join(", ")
      prices = product_service.find_prices_by_product_ids product_ids

      latest_products.map do |product|
        {
          id: product["ProductCode"],
          name: product["Name"],
          sku: product["ProductCode"],
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

    def latest_products
      @latest_products ||= product_service.latest_updates config[:salesforce_products_since]
    end

    def latest_timestamp_update(products = nil)
      if product = (products || latest_products).to_a.last
        Time.parse(product["LastModifiedDate"]).utc.iso8601
      else
        Time.now.utc.iso8601
      end
    end

    def price_from_product_id(prices, product_id)
      if price = prices.find { |p| p["Product2Id"] == product_id }
        price["UnitPrice"]
      end
    end

    def order_product_params(payload_item)
      Integration::Builder::OrderProduct.new(payload_item).build
    end

    private

    def with_currency(item)
      item.merge({ 'Currency' => look_up('currency') })
    end

    def product_params
      Integration::Builder::Product.new(object).build
    end

    def look_up(what)
      object['order'][what]
    end
  end
end
