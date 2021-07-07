module Integration
  class Product < Base
    delegate :find_id_by_code, :create!, :standard_pricebook, :setup_pricebook_entry,
      to: :product_service

    attr_reader :object

    def initialize(config, object)
      @object = object
      @now = Time.now.utc.iso8601
      super(config)
    end

    def upsert!(attributes = nil)
      attributes ||= Integration::Builder::Product.new(object).build

      if product_id = find_id_by_code(attributes['ProductCode'])
        attributes.merge! "Id" => product_id
      end

      product_service.upsert! attributes
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

    def latest_products
      @latest_products ||= product_service.latest_updates config[:salesforce_products_since]
    end

    def latest_timestamp_update(products = nil)
      if product = (products || latest_products).to_a.last
        Time.parse(product["LastModifiedDate"]).utc.iso8601
      else
        @now
      end
    end

    def price_from_product_id(prices, product_id)
      if price = prices.find { |p| p["Product2Id"] == product_id }
        price["UnitPrice"]
      end
    end
  end
end
