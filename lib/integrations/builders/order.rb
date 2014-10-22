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
          'Pricebook2Id'           => object['price_book_id'],
          'StageName'              => object.has_key?('stage_name') ? object['stage_name'] : object['status'],
          'CurrencyIsoCode'        => object['currency']
        }
      end
    end
  end
end
