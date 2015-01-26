module Integration
  module Builder
    class Order
      attr_reader :object

      def initialize(object)
        @object = object
      end

      # Amount is rejected when Opportunity has products, the amount will
      # then be calculated based on the sum of products
      def build
        params = {
          'Amount'                 => object['totals']['order'],
          'Probability'            => '100',
          'CloseDate'              => object['placed_on'],
          'Name'                   => object['id'],
          'Pricebook2Id'           => object['price_book_id'] || 'Standard Price Book',
          'LeadSource'             => object['lead_source'] || 'Web',
          'StageName'              => 'closed-won'
        }.merge Hash(object['opportunity_custom_fields'])
      end
    end
  end
end
