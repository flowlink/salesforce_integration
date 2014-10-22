module Integration
  module Builder
    class Payment

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Title'     => "Payment:#{object['number']}",
          'Body'      => build_body(object),
          'IsPrivate' => false,
        }
      end

      def build_body(object)
        <<-body
Number: #{object['number']}
Status: #{object['status']}
Amount: #{object['amount']}
Payment Method: #{object['payment_method']}
        body
      end
    end
  end
end
