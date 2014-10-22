module SFService
  class Payment < Base
    def initialize(config)
      super("Note", config)
    end

    def is_present?(number)
      results = salesforce.query("select Id from Note where Title = 'Payment:#{number}'")
      results.any? ? results.first.fetch('Id') : nil
    end

    def find_order(id)
      results = salesforce.query("select Id from Opportunity where Name = '#{id}'")
      results.any? ? results.first['Id'] : nil
    end

    def upsert!(payment_attr = {}, order_code, email)
      order_id = find_order(order_code)

      payment_attr = payment_attr.merge( { 'ParentId' => order_id } ) if order_id.present?

      payment_id = is_present?(payment_attr.fetch 'Title')
      payment_id.present? ? update!(payment_attr.merge({ Id: payment_id })) : create!(payment_attr)
    end
  end
end
