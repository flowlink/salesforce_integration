module SFService
  class Order < Base
    def initialize(config)
      super("Opportunity", config)
      @account_service = SFService::Account.new(config)
    end

    def find_opportunity_id_by_name(name)
      results = salesforce.query("SELECT Id FROM Opportunity WHERE Name = '#{name}' LIMIT 1")
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
      price_book_id = find_price_book_by_id(order_attr.fetch 'Pricebook2Id')

      order_attr = order_attr.merge( { 'Pricebook2Id' => price_book_id } ) if price_book_id.present?

      if opportunity_id = find_opportunity_id_by_name(order_attr.fetch 'Name')
        update! order_attr.merge(Id: opportunity_id)
        opportunity_id
      else
        create!(order_attr)
      end
    end
  end
end
