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

    def upsert_lineitems!
      Integration::LineItem.new(config, payload[service_name]).import!
    end

    def upsert_payments!
      Integration::Payment.new(config, payload[service_name]).import!
    end

    def upsert_products!
      Integration::Product.new(config, payload).import_from_order!
    end

    def upsert_order!
      Integration::Order.new(config, payload).upsert!
    end

    def handle_returns!
      Integration::Return.new(config, payload[service_name]).handle_all!
    end
  end
end
