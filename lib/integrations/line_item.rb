module Integration
  class LineItem < Base

    attr_reader :object

    def initialize(config, object)
      @object = object.with_indifferent_access
      super(config)
    end

    def upsert!(item)
      line_item_service.upsert!(item_params(item))
    end

    def import!
      look_up('line_items').each { |li| upsert!(li) }
    end

    def look_up(what)
      object[what]
    end

    def item_params(item)
      Integration::Builder::LineItem.new(item.merge( { 'order_id' => look_up('id') } )).build
    end

  end
end
