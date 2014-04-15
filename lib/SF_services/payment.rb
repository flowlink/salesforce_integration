module SFService
  class Payment < Base
    def initialize(config)
      super("Payment__c", config)
    end

    def is_present?(number)
      results = salesforce.query("select Id from Payment__c where Number__c = '#{number}'")
      results.any? ? results.first.fetch('Id') : nil
    end

    def find_order(id)
      results = salesforce.query("select Id from Order__c where Id__c = '#{id}'")
      results.any? ? results.first['Id'] : nil
    end

    def upsert!(payment_attr = {}, order_code)
      order_id = find_order(order_code)
      payment_attr = payment_attr.merge( { 'Order__c' => order_id } ) if order_id.present?

      payment_id = is_present?(payment_attr.fetch 'Number__c')
      payment_id.present? ? update!(payment_id.merge({ Id: payment_id })) : create!(payment_attr)
    end
  end
end
