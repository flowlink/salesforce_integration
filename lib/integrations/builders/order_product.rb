module Integration
  module Builder
    class OrderProduct

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Name'          => object['name'],
          'ProductCode'   => object['product_id'],
          'DefaultPrice'  => object['price']
        }
      end
    end
  end
end
