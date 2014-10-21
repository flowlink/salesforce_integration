module SFService
  class Order < Base
    def initialize(config)
      super("Order__c", config)
    end

    def is_present?(id)
      results = salesforce.query("select Id from Opportunity where Name = '#{id}'")
      results.any? ? results.first.fetch('Id') : nil
    end

    def find(id)
      salesforce.find('Opportunity', id, 'Name')
    end

    def find_account_id_by_email(email)
      results = salesforce.query("select Id from Account where PersonEmail = '#{email}'")
      results.any? ? results.first['Account__c'] : nil
    end

    def upsert!(order_attr = {})
      email = order_attr.fetch 'AccountId'
      account_id  = find_account_id_by_email(email)

      order_attr = order_attr.merge( { 'AccountId' => account_id } ) if account_id.present?

      order_id = is_present?(order_attr.fetch 'Name')
      order_id.present? ? update!(order_attr.merge({ Id: order_id })) : create!(order_attr)
    end
  end
end
