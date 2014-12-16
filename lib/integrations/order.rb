module Integration
  class Order < Base

    attr_reader :object

    def initialize(config, object)
      @object = object
      super(config)
    end

    def upsert!
      contact_account = ContactAccount.new(config, object[:order])
      account_id = contact_account.account_id
      contact_account.upsert! AccountId: account_id

      params = order_params.merge "AccountId" => account_id
      opportunity_id = order_service.upsert! params

      Integration::LineItem.new(config, object[:order]).upsert! opportunity_id
    end

    private

    def order_params
      Integration::Builder::Order.new(object['order']).build
    end
  end
end
