module SalesforceIntegration
  module Service
    class OrderClientBuilder

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'email'            => object['email'],
          'shipping_address' => object['shipping_address'],
          'billing_address'  => object['billing_address'],
        }
      end
    end
  end
end
