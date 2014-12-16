module Integration
  module Builder
    class LineItem

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Quantity'        => object['quantity'],
          'UnitPrice'       => object['price'],
          # 'CurrencyIsoCode' => object['currency'],
        }
      end
    end
  end
end
