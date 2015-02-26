module Integration
  class Base

    attr_reader :config

    def initialize(config, payload = {})
      @config = config
      config[:salesforce] ||= SFService::Base.new("Foo", config).client
    end

    def custom_objects_upsert(params)
      params.each do |object_name, attributes|
        custom_service = SFService::Base.new(object_name, config)
        custom_service.create! attributes
      end
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

    def note_service
      @note_service ||= SFService::Note.new(config)
    end

    def return_service
      @return_service ||= SFService::Return.new(config)
    end

    def pricebook_entry_service
      @pricebook_entry_service ||= SFService::Base.new "PricebookEntry", config
    end
  end
end
