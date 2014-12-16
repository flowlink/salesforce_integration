module Integration
  module Builder
    class Return

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Title'     => "Return:#{object['id']}",
          'Body'      => build_body(object),
          'IsPrivate' => false
        }
      end

      def build_body(object)
        <<-body
Status: #{object['status']}
Amount: #{object['refund_amount']}
Extra: #{object['extra']}
        body
      end
    end
  end
end
