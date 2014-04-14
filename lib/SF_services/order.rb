module SFService
  class Order < Base
    def initialize(config)
      super("Order__c", config)
    end

    def is_present?(id)
      results = salesforce.query("select Id from Order__c where Id__c = '#{id}'")
      results.any? ? results.first.fetch('Id') : nil
    end

    def find_client(email)
      results = salesforce.query("select Id from Contact where Email = '#{email}'")
      results.any? ? results.first.fetch('Id') : nil
    end

    def upsert!(order_attr = {})
      contact_id = find_client(order_attr.fetch 'Email__c')
      order_attr = order_attr.merge({ 'ContactId__c'=> contact_id }) if contact_id.present?

      order_id = is_present?(order_attr.fetch 'Id__c')
      order_id.present? ? update!(order_attr.merge({ Id: order_id })) : create!(order_attr)
    end
  end
end
