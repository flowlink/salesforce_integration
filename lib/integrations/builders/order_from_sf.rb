module Integration
  module Builder
    class OrderFromSf

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = @object.select do |k, v|
          [
            'Id',
            'Id__c',
            'Name',
            'OwnerId',
            'ContactId__c',
            'Account__c',
            'Status__c',
            'Channel__c',
            'Email__c',
            'Currency__c',
            'PlacedOn__c',
            'Subtotal__c',
            'Adjustment__c',
            'Tax__c',
            'Shipping__c',
            'Payment__c',
            'Total__c'
          ].include?(k)
        end
      end

    end
  end
end
