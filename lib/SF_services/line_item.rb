module SFService
  class LineItem < Base

    def initialize(config)
      super("OpportunityLineItem", config)
    end

    def find_line_item(order_id, product_id)
      results = salesforce.query("select Id from OpportunityLineItem where OpportunityId = '#{order_id}' and PricebookEntryId = '#{product_id}'")
      results.any? ? results.first['Id'] : nil
    end

    def upsert!(line_item_attr = {}, opportunity_id, pricebook_entry_id)
      if line_item_id = find_line_item(opportunity_id, pricebook_entry_id)
        update! line_item_attr.merge(Id: line_item_id)
      else
        line_item_attr = line_item_attr.merge OpportunityId: opportunity_id, PricebookEntryId: pricebook_entry_id
        create! line_item_attr
      end
    end
  end
end
