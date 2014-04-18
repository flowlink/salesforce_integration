module Integration
  module Builder
    class Order

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Id__c'            => object['id'],
          'Status__c'        => object['status'],
          'Channel__c'       => object['channel'],
          'Email__c'         => object['email'],
          'Currency__c'      => object['currency'],
          'PlacedOn__c'      => object['placed_on'],
          'Subtotal__c'      => object['totals']['item'],
          'Adjustment__c'    => object['totals']['adjustment'],
          'Tax__c'           => object['totals']['tax'],
          'Shipping__c'      => object['totals']['shipping'],
          'Payment__c'       => object['totals']['payment'],
          'Total__c'         => object['totals']['order'],
        }
      end

    end
  end
end
