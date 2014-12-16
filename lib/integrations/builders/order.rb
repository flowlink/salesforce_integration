module Integration
  module Builder
    class Order

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Amount'                 => object['totals']['order'],
          'CloseDate'              => object['placed_on'],
          # 'HasOpportunityLineItem' => true,
          'Name'                   => object['id'],
          'Pricebook2Id'           => object['price_book_id'] || 'Standard Price Book',
          'StageName'              => 'closed-won',
          # 'CurrencyIsoCode'        => object['currency']
        }
      end
    end
  end
end
