module Integration
  class LineItem < Base

    attr_reader :object

    def initialize(config, object)
      @object = object.with_indifferent_access
      super(config)
    end

    def upsert!(item)
      line_item_service.upsert!(item_params(item), look_up('id'), item.fetch('product_id'))
    end

    def import!
      look_up('line_items').each { |li| upsert!(li) }
    end

    def look_up(what)
      object[what]
    end

    def item_params(item)
      Integration::Builder::LineItem.new(item).build
    end

  end
end
