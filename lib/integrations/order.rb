module Integration
  class Order < Base

    attr_reader :object

    def initialize(config, object)
      @object = object
      super(config)
    end

    def upsert!
      contact_account = ContactAccount.new(config, object[:order])
      account_id = contact_account.account_id
      contact_account.upsert! AccountId: account_id

      params = order_params.merge "AccountId" => account_id
      opportunity_id = order_service.upsert! params

      product_integration = Product.new(config, object[:order])
      line_item_integration = LineItem.new(config, object[:order])

      object[:order][:line_items].each do |line_item|

        unless product_id = product_integration.find_id_by_code(line_item[:product_id])
          params = product_integration.order_product_params
          params.merge Currency: object[:order][:currency]

          product_id = product_integration.create! params
        end
      end

      LineItem.new(config, object[:order]).upsert! opportunity_id
    end

    private

    def order_params
      Builder::Order.new(object[:order]).build
    end
  end
end
