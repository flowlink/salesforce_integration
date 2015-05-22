module SFService
  class Product < Base
    attr_reader :config

    def initialize(config)
      super("Product2", config)
    end

    def standard_pricebook(pricebook_name = nil)
      if pricebook_name
        standard = salesforce.query("SELECT Id FROM Pricebook2 WHERE Name = '#{pricebook_name}'").first
      else
        standard = salesforce.query("SELECT Id FROM Pricebook2 WHERE isStandard = true").first
      end

      raise SalesfoceIntegrationError, "Standard Pricebook not found" unless standard
      standard
    end

    def find_pricebook_entry(pricebook_id, product_id)
      filter = "where Pricebook2Id = '#{pricebook_id}' and Product2Id = '#{product_id}'"
      results = salesforce.query "SELECT Id, IsActive FROM PricebookEntry #{filter}"
      results.first
    end

    def find_id_by_code(product_code)
      results = salesforce.query("select Id from Product2 where ProductCode = '#{product_code}'")
      results.any? ? results.first['Id'] : nil
    end

    def latest_updates(time = Time.now.utc.iso8601)
      since = time ? Time.parse(time).utc.iso8601 : Time.now.utc.iso8601

      fields = "Id, Name, ProductCode, Description, LastModifiedDate"
      filter = "LastModifiedDate > #{since} ORDER BY LastModifiedDate ASC LIMIT 100"
      salesforce.query("select #{fields} from Product2 where #{filter}")
    end

    def find_prices_by_product_ids(product_ids)
      fields = "Product2Id, UnitPrice"
      salesforce.query("select #{fields} from PricebookEntry where Product2Id in (#{product_ids})")
    end

    def setup_pricebook_entry(standard_id, product_id, price)
      pricebook_entry_service = SFService::Base.new "PricebookEntry", config
      pricebook_entry = find_pricebook_entry standard_id, product_id

      if pricebook_entry
        pricebook_entry["Id"]
      else
        pricebook_entry_service.create!(
          Pricebook2Id: standard_id,
          Product2Id: product_id,
          UnitPrice: price,
          IsActive: true
        )
      end
    end

    def upsert!(attributes = {})
      product_id = attributes["Id"]

      standard_id = standard_pricebook["Id"]
      price = attributes.delete "DefaultPrice"

      if product_id
        update! attributes
      else
        product_id = create! attributes
      end

      setup_pricebook_entry standard_id, product_id, price

      product_id
    end
  end
end
