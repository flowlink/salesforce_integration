module SalesforceIntegration
  class Base
    attr_accessor :payload, :config

    def initialize(payload, config)
      @payload = payload.is_a?(Array) ? payload.map(&:with_indifferent_access) : payload.with_indifferent_access
      @config = config
    end

    def contact_service
      @contact_service ||= Service::Contact.new(config)
    end

    def product_service
      @product_service ||= Service::Product.new(config)
    end

    def order_service
      @order_service ||= Service::Order.new(config)
    end
  end
end
