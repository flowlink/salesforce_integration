module SFService
  class Order < Base
    def initialize(config)
      super("Opportunity", config)
      @account_service = SFService::Account.new(config)
    end

    def is_present?(id)
      results = salesforce.query("select Id from Opportunity where Name = '#{id}'")
      results.any? ? results.first.fetch('Id') : nil
    end

    def find(id)
      salesforce.find('Opportunity', id, 'Name')
    end

    def find_price_book_by_id(price_book_id)
      results = salesforce.query("select Id from PriceBook2 where Name = '#{price_book_id}'")
      results.any? ? results.first['Id'] : nil
    end

    def upsert!(order_attr = {})
      account_id    = @account_service.find_account_id_by_email(order_attr.fetch 'AccountId')
      price_book_id = find_price_book_by_id(order_attr.fetch 'Pricebook2Id')

      order_attr = order_attr.merge( { 'AccountId'    => account_id } ) if account_id.present?
      order_attr = order_attr.merge( { 'Pricebook2Id' => price_book_id } ) if price_book_id.present?

      order_id = is_present?(order_attr.fetch 'Name')
      order_id.present? ? update!(order_attr.merge({ Id: order_id })) : create!(order_attr)
    end
  end
end
