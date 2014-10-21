module SFService
  class Product < Base
    attr_reader :config

    def initialize(config)
      super("Product2", config)
    end

    def standard_pricebook
      salesforce.query "select Id from Pricebook2 where isStandard=true"
    end

    def find_id_by_code(product_code)
      results = salesforce.query("select Id from Product2 where ProductCode = '#{product_code}'")
      results.any? ? results.first['Id'] : nil
    end

    def upsert!(product_code, attributes = {})
      product_id = find_id_by_code(product_code)

      pricebookentry = SFService::Base.new "PricebookEntry", config

      # NOTE Raise if it cant find a standard pricebook?
      standard = standard_pricebook.first

      price = attributes.delete "DefaultPrice"

      if product_id.present?
        update!(attributes.merge({ Id: product_id }))

        result = salesforce.query "select Id from PricebookEntry where Pricebook2Id = '#{standard["Id"]}' and Product2Id = '#{product_id}'"
        pricebookentry_id = result.first["Id"]

        pricebookentry.update!(Id: pricebookentry_id, UnitPrice: price)
      else
        product_id = create!(attributes)
        pricebookentry.create!(
          Pricebook2Id: standard["Id"],
          Product2Id: product_id,
          UnitPrice: price
        )
      end

      product_id
    end
  end
end
