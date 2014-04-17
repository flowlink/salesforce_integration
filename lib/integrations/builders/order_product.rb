module Integration
  module Builder
    class OrderProduct

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Name'          => object['name'],
          'ProductCode'   => object['product_id'],
          'Price__c'      => object['price'],
          'ExternalID__c' => object['product_id'],
        }
      end

    end
  end
end
