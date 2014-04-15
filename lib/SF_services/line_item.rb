module SFService
  class LineItem < Base
    def initialize(config)
      super("LineItem__c", config)
    end

    def find_order(order_code)
      results = salesforce.query("select Id from Order__c where Id__c = '#{order_code}'")
      results.any? ? results.first['Id'] : nil
    end

    def find_product(product_code)
      results = salesforce.query("select Id from Product2 where ProductCode = '#{product_code}'")
      results.any? ? results.first['Id'] : nil
    end

    def upsert!(line_item_attr = {})
      order_id   = find_order(line_item_attr['Order'])
      product_id = find_product(line_item_attr['Product'])

      create!(line_item_attr.merge( { 'Order__c' => order_id } ))
    end
  end
end
