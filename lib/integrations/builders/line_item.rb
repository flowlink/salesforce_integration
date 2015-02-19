module Integration
  module Builder
    class LineItem
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def build
        params = {
          'Quantity'        => object['quantity'],
          'UnitPrice'       => object['price']
        }
      end
    end
  end
end
