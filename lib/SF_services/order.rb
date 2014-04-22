module SFService
  class Order < Base
    def initialize(config)
      super("Order__c", config)
    end

    def is_present?(id)
      results = salesforce.query("select Id from Order__c where Id__c = '#{id}'")
      results.any? ? results.first.fetch('Id') : nil
    end

    def find(id)
      salesforce.find('Order__c', id, 'Id__c')
    end

    def find_client(email)
      results = salesforce.query("select Id from Contact where Email = '#{email}'")
      results.any? ? results.first.fetch('Id') : nil
    end

    def find_account_id_by_email(email)
      results = salesforce.query("select Account__c from Contact where Email = '#{email}'")
      results.any? ? results.first['Account__c'] : nil
    end

    def upsert!(order_attr = {})
      email = order_attr.fetch 'Email__c'
      contact_id  = find_client(email)
      account_id  = find_account_id_by_email(email)

      order_attr = order_attr.merge( { 'ContactId__c' => contact_id } ) if contact_id.present?
      order_attr = order_attr.merge( { 'Account__c' => account_id } ) if account_id.present?

      order_id = is_present?(order_attr.fetch 'Id__c')
      order_id.present? ? update!(order_attr.merge({ Id: order_id })) : create!(order_attr)
    end
  end
end
