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
      line_item_integration = LineItem.new(config)

      object[:order][:line_items].each do |line_item|

        unless product_id = product_integration.find_id_by_code(line_item[:product_id])
          params = product_integration.order_product_params
          params.merge Currency: object[:order][:currency]

          product_id = product_integration.create! params
        end

        line_item_integration.upsert! line_item, opportunity_id, product_id
      end
    end

    private

    def order_params
      Builder::Order.new(object[:order]).build
    end
  end

  class LineItem < Base
    def upsert!(item, opportunity_id, product_id)
      params = build_oportunity_line item
      line_item_service.upsert!(params, opportunity_id, product_id)
    end

    def build_oportunity_line(item)
      Builder::LineItem.new(item).build
    end
  end
end
