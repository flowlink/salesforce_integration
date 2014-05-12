module Integration
  module Builder
    class PaymentFromReturn

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Name'      => "0",
          'Status__c' => "returned",
          'Amount__c' => object['amount'],
          'Method__c' => "-",
        }
      end
    end
  end
end
