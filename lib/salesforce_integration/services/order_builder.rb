module SalesforceIntegration
  module Service
    class OrderBuilder

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Status__c'    => object['status'],
          'Channel__c'   => object['channel'],
          'Email__c'     => object['email'],
          'Currency__c'  => object['currency'],
          'Placed_on__c' => object['placed_on'],
        }
      end
    end
  end
end
