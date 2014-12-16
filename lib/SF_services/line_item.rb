module SFService
  class LineItem < Base

    def initialize(config)
      super("OpportunityLineItem", config)
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

    def upsert!(line_item_attr = {}, opportunity_id, product_id)
      # FIXME same here standard price book id is already fetched before
      unless standard = salesforce.query("select Id from Pricebook2 where isStandard=true").first
        raise SalesfoceIntegrationError, "Standard price book when building opportunity line"
      end

      standard_id = standard['Id']

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

      if line_item_id = find_line_item(opportunity_id, pricebook_entry_id)
        update!(line_item_attr.merge Id: line_item_id )
      else
        line_item_attr = line_item_attr.merge OpportunityId: opportunity_id, PricebookEntryId: pricebook_entry_id
        create!(line_item_attr)
      end
    end
  end
end
