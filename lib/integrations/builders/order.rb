module Integration
  module Builder
    class Order

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'AccountId'              => object['email'],
          'Amount'                 => object['totals']['order'],
          'CloseDate'              => object['placed_on'],
          'HasOpportunityLineItem' => true,
          'Name'                   => object['id'],
          'Pricebook2Id'           => get_pricebook2,
          'StageName'              => object['status'],
          'CurrencyIsoCode'        => object['currency']
        }
      end

      def get_pricebook2

      end
    end
  end
end
