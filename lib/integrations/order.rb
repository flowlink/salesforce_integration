module Integration
  class Order < Base

    attr_reader :object

    def initialize(config, object)
      @object = object
      super(config)
    end

    # Related docs:
    #
    # http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_objects_opportunity.htm
    # http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_objects_opportunitylineitem.htm
    def upsert!
      # Create or Update the Contact. Set the account id
      contact_account = ContactAccount.new(config, object[:order])
      account_id = contact_account.account_id
      contact_account.upsert! AccountId: account_id

      # Create or Update the Opportunity. Set the opportunity id
      params = order_params.merge AccountId: account_id
      opportunity_id = order_service.upsert! params

      product_integration = Product.new(config, object[:order])
      line_item_integration = LineItem.new(config)

      # Opportunity lines needs to ref a product pricebook entry
      standard_id = product_integration.standard_pricebook["Id"]

      object[:order][:line_items].each do |line_item|

        # Create Product in case it doesn't exist in Salesforce yet
        unless product_id = product_integration.find_id_by_code(line_item[:product_id])
          attributes = Builder::Product.new(line_item).build.except "DefaultPrice"
          attributes.merge Currency: object[:order][:currency]
          product_id = product_integration.create! attributes
        end

        # Create (if not found) pricebook entry
        pricebook_entry_id = product_integration.setup_pricebook_entry standard_id, product_id, line_item[:price]

        # Create or Update Opportunity line
        line_item_integration.upsert! line_item, opportunity_id, pricebook_entry_id
      end

      payment_integration = Payment.new(config)

      object[:order][:payments].each do |payment|
        payment_integration.upsert! payment, opportunity_id
      end
    end

    def fetch_updates
      return [] if latest_opportunities.to_a.empty?
    end

    def latest_opportunities
      @latest_opportunities ||= order_service.latest_updates config[:salesforce_orders_since]
    end

    private
      def order_params
        Builder::Order.new(object[:order]).build
      end
  end

  class LineItem < Base
    def upsert!(item, opportunity_id, pricebook_entry_id)
      params = Builder::LineItem.new(item).build
      line_item_service.upsert!(params, opportunity_id, pricebook_entry_id)
    end
  end

  class Payment < Base
    def upsert!(payment, opportunity_id)
      attributes = Integration::Builder::Payment.new(payment).build
      payment_service.upsert! attributes, opportunity_id
    end
  end
end
