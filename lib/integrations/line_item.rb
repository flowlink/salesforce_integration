module Integration
  class LineItem < Base

    attr_reader :object, :order_id

    def initialize(config, object, order_id)
      @object   = object.with_indifferent_access
      @order_id = order_id
      super(config)
    end

    def upsert!
      line_item_service.upsert!(item_params['Product__c'], item_params)
    end

    def build
      Integration::Builder::LineItem.new(object.merge('order_id' => order_id)).build
    end

  end
end
