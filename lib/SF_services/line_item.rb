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

    def find_line_item(order_id, product_id)
      results = salesforce.query("select Id from LineItem__c where Order__c = '#{order_id}' and Product__c = '#{product_id}'")
      results.any? ? results.first['Id'] : nil
    end

    def upsert!(line_item_attr = {}, order_code, product_code)
      order_id     = find_order(order_code)
      product_id   = find_product(product_code)
      line_item_id = find_line_item(order_id, product_id)

      line_item_attr = [line_item_attr, { 'Order__c' => order_id }, { 'Product__c' => product_id }].reduce &:merge
      line_item_id.present? ? update!(line_item_attr) : create!(line_item_attr)
    end
  end
end
