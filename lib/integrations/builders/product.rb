module Integration
  module Builder
    class Product

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Name' => object['name'],
          'ProductCode'  => object['sku'],
          'Description' => object['description'],
          'Price__c' => object['price'],
          'ExternalID__c' => object['sku']
        }
      end
    end
  end
end
