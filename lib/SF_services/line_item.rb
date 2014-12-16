module SFService
  class LineItem < Base

    def initialize(config)
      super("OpportunityLineItem", config)
    end

    def find_order(order_code)
      results = salesforce.query("select Id from Opportunity where Name = '#{order_code}'")
      results.any? ? results.first['Id'] : nil
    end

    def find_pricebook_entry(standard_id, product_id)
      filter = "where Pricebook2Id = '#{standard_id}' and Product2Id = '#{product_id}'"
      results = salesforce.query "select Id, IsActive from PricebookEntry #{filter}"
      results.first
    end

    def find_line_item(order_id, product_id)
      results = salesforce.query("select Id from OpportunityLineItem where OpportunityId = '#{order_id}' and PricebookEntryId = '#{product_id}'")
      results.any? ? results.first['Id'] : nil
    end

    def upsert!(line_item_attr = {}, order_code, product_code)
      order_id     = find_order(order_code)

      # FIXME product ids are already fetched before on the stack
      results = salesforce.query("select Id from Product2 where ProductCode = '#{product_code}'")
      raise SalesfoceIntegrationError, "Product #{product_code} not found" unless results.first

      product_id = results.first["Id"]

      # FIXME same here standard price book id is already fetched before
      unless standard = salesforce.query("select Id from Pricebook2 where isStandard=true").first
        raise SalesfoceIntegrationError, "Standard price book not found for #{product_code}"
      end

      standard_id = standard['Id']
      product_id = results.first['Id']

      pricebookentry = SFService::Base.new "PricebookEntry", config

      pricebook_entry = find_pricebook_entry(standard_id, product_id) 

      if pricebook_entry && !pricebook_entry["IsActive"]
        pricebook_entry_id = pricebook_entry["Id"]
        pricebookentry.update!(IsActive: true, Id: pricebook_entry_id)
      else
        pricebook_entry_id = pricebook_entry["Id"]
      end

      unless pricebook_entry
        pricebook_entry_id = pricebookentry.create!(
          Pricebook2Id: standard["Id"],
          Product2Id: product_id,
          UnitPrice: line_item_attr["UnitPrice"],
          IsActive: true
        )
      end

      if line_item_id = find_line_item(order_id, pricebook_entry_id)
        line_item_attr = line_item_attr.merge OpportunityId: order_id , PricebookEntryId: pricebook_entry_id
        create!(line_item_attr)
      else
        update!(line_item_attr.merge Id: line_item_id )
      end
    end
  end
end
