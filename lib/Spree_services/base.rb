module SpreeService
  class Base

    attr_accessor :payload, :config, :service_name

    def initialize(service_name, payload, config)
      @payload = payload.is_a?(Array) ? payload.map(&:with_indifferent_access) : payload.with_indifferent_access
      @config = config
      @service_name = service_name
    end

    def upsert_contact_with_account!
      Integration::ContactAccount.new(config, payload[service_name]).upsert!
    end

    def upsert_order!
      Integration::Order.new(config, payload).upsert!
    end

    def upsert_product!
      Integration::Product.new(config, payload).upsert! # need to pass the whole payload -> need to handle multiple products
    end

    def import_products!
      Integration::Product.new(config, payload).import!
    end
  end
end
