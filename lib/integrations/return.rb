module Integration
  class Return < Base

    attr_reader :object

    def initialize(config, object)
      @object = object.map(&:with_indifferent_access)
      super(config)
    end

    def handle_all!
      @object.each { |_return| handle _return }
    end

    def handle _return
      order = order_service.find(_return["order_id"])
      notes = order["Notes__c"]
      returned_items = _return["inventory_units"].map{|item| item["variant"]["sku"]}
      returned_counts = returned_items.inject(Hash.new(0)) { |total, item| total[item] += 1; total }
      result = notes.presence || "Returned items: "
      returned_counts.each { |item_name, count| result += "#{item_name}: (#{count}) " }
      order_service.update!(order_params(order).merge({"Notes__c" => result}))
    end

    private

    def order_params order
      Integration::Builder::OrderFromSf.new(order).build
    end
  end
end
