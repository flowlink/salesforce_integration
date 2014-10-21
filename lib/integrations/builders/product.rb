module Integration
  module Builder
    # https://www.salesforce.com/us/developer/docs/api/Content/sforce_api_objects_product2.htm#topic-title
    #
    # These give us: INVALID_FIELD: No such column 'DefaultPrice' on sobject of type Product2
    #
    #   DefaultPrice
    #   CurrencyIsoCode
    #
    # It still sets the DefaultPrice though so it can be fetched later to set
    # up the PricebookEntry record
    class Product
      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Name'          => object['name'],
          'ProductCode'   => object['id'] || object['product_id'],
          'Description'   => object['description'],
          'DefaultPrice'  => object['price']
        }
      end
    end
  end
end
