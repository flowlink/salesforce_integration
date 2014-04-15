module Integration
  module Builder
    class LineItem

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Product'     => object['product_id'],
          'Order'       => object['order_id'],
          'Quantity__c' => object['quantity'],
          'Price__c'    => object['price'],
        }
      end

    end
  end
end
