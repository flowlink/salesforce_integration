module Integration
  class Base

    attr_reader :config

    def initialize(config)
      @config = config.with_indifferent_access
    end

    private

    def contact_service
      @contact_service ||= SFService::Contact.new(config)
    end

    def product_service
      @product_service ||= SFService::Product.new(config)
    end

    def account_service
      @account_service ||= SFService::Account.new(config)
    end

    def order_service
      @order_service ||= SFService::Order.new(config)
    end

    def line_item_service
      @line_item_service ||= SFService::LineItem.new(config)
    end

    def payment_service
      @payment_service ||= SFService::Payment.new(config)
    end
  end
end
