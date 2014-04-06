module SalesforceIntegration
  module Service
    class ProductBuilder

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Name' => object['name'],
          'ProductCode'  => object['sku'],
          'Description' => object['description'],
          'Price__c' => object['price']
        }
      end
    end
  end
end
