module Integration
  class LineItem < Base

    attr_reader :order, :items

    def initialize(config, order)
      @order = order
      @items = order[:line_items]

      super(config)
    end

    def upsert!(opportunity_id)
      items.each do |item|
        params = item_params(item)
        line_item_service.upsert!(params, opportunity_id, item.fetch('product_id'))
      end
    end

    def item_params(item)
      Integration::Builder::LineItem.new(item).build
    end
  end
end
