module SalesforceIntegration
  module Service
    class PaymentBuilder

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Number__c'         => object['number'],
          'Status__c'         => object['status'],
          'Amount__c'         => object['amount'],
          'PaymentMethod__c'  => object['payment_method'],
        }
      end
    end
  end
end
