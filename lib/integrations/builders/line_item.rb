module Integration
  module Builder
    class LineItem

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Quantity__c' => object['quantity'],
          'Price__c'    => object['price'],
          'Currency__c' => object['currency'],
        }
      end

    end
  end
end
