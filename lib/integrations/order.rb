module Integration
  class Order < Base

    attr_reader :object

    def initialize(config, object = {})
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

      if object[:order][:sf_record_type_id]
        contact_account.person_contact_update account_id
      elsif has_address?
        contact_account.upsert! AccountId: account_id
      end

      product_integration = Product.new(config, object[:order])
      line_item_integration = LineItem.new(config)

      # Opportunity lines needs to ref a product pricebook entry
      standard_id = product_integration.standard_pricebook(object[:order][:sf_pricebook_name])["Id"]

      # Create or Update the Opportunity. Set the opportunity id
      params = order_params.merge AccountId: account_id, Pricebook2Id: standard_id
      opportunity_id = order_service.upsert! params

      object[:order][:line_items].to_a.each do |line_item|

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

      object[:order][:payments].to_a.each do |payment|
        payment_integration.upsert! payment, opportunity_id
      end

      custom_objects_upsert object[:order][:salesforce_custom]
    end

    def fetch_updates
      latest_opportunities.map do |o|
        account = accounts_by_id.find { |a| a[:Id] == o[:Account][:Id] }
        contact = account[:Contacts].to_a.first.to_h

        order = {
          id: o[:Name],
          email: contact['Email'],
          placed_on: o[:CloseDate],
          channel: 'salesforce',
          updated_at: o[:LastModifiedDate],
          totals: {
            order: o[:Amount]
          },
          line_items: build_line_items(o[:OpportunityLineItems]),
          payments: build_payments(o[:Notes]),
          shipping_address: build_address(account, "Shipping"),
          billing_address: build_address(account),
          salesforce_id: o[:Id],
          sf_account_name: account.to_h['Name']
        }

        grab_custom_fields(o).merge order
      end
    end

    def latest_opportunities
      @latest_opportunities ||= order_service.latest_updates(config[:salesforce_orders_since]).to_a
    end

    def accounts_by_id
      ids = latest_opportunities.map { |o| "'#{o[:Account][:Id]}'" }
      @accounts_by_id ||= account_service.fetch_contacts_along ids
    end

    def latest_timestamp_update(orders = nil)
      if order = (orders || latest_opportunities).last
        Time.parse(order["LastModifiedDate"]).utc.iso8601
      else
        Time.now.utc.iso8601
      end
    end

    private
      def has_address?
        object[:order][:billing_address] || object[:order][:shipping_address]
      end

      def grab_custom_fields(opportunity)
        order_service.custom_fields.each_with_object({}) do |field, customs|
          customs[field] = opportunity[field]
        end
      end

      def build_payments(notes)
        notes.to_a.map do |note|
          {
            title: note[:Title],
            body: note[:Body]
          }
        end
      end

      def build_address(account, kind = "Billing")
        {
          address1: account["#{kind}Street"],
          zipcode: account["#{kind}PostalCode"],
          city: account["#{kind}City"],
          country: account["#{kind}Country"],
          state: account["#{kind}State"],
          phone: account["Phone"]
        }
      end

      def build_line_items(opportunity_lines)
        opportunity_lines.to_a.map do |line|
          {
            name: line[:PricebookEntry][:Product2][:Name],
            product_id: line[:PricebookEntry][:Product2][:ProductCode],
            price: line[:UnitPrice],
            quantity: line[:Quantity]
          }
        end
      end

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
      note_service.upsert! attributes, opportunity_id
    end
  end
end
