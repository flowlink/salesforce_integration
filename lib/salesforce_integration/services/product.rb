module SalesforceIntegration
  module Service
    class Product < Base

      def initialize(config)
        super("Product2", config)
      end

      def find_id_by_code(product_code)
        results = salesforce.query("select Id from Product2 where ProductCode = '#{product_code}'")
        results.any? ? results.first['Id'] : nil
      end

      def upsert!(product_code, attributes = {})
        product_id = find_id_by_code(product_code)
        product_id.present? ? update!(attributes.merge({ Id: product_id })) : create!(attributes)
      end
    end
  end
end
