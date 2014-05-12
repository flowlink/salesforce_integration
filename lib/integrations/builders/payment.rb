module Integration
  module Builder
    class Payment

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Name'      => object['number'],
          'Status__c' => object['status'],
          'Amount__c' => object['amount'],
          'Method__c' => object['payment_method'],
        }
      end
    end
  end
end
