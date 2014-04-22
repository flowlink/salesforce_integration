module Integration
  class Return < Base

    attr_reader :object

    def initialize(config, object)
      @object = object.map(&:with_indifferent_access)
      super(config)
    end

    def handle_all!
      @object.each { |_return| handle _return }
      @object.each { |_return| handle_payment _return }
    end

    def handle _return
      returned_items = _return["inventory_units"].map{|item| item["variant"]["sku"]}
      returned_counts = returned_items.inject(Hash.new(0)) { |total, item| total[item] += 1; total }
      result = "Returned items: "
      returned_counts.each { |item_name, count| result += "#{item_name}: (#{count}) " }
      order_service.update!(order_params(_return).merge({"Notes__c" => result}))
    end

    def handle_payment _return
      payment_service.upsert!(payment_params(_return), _return["order_id"], order(_return)["Email__c"])
    end

    private

    def order _return
      @order ||= order_service.find(_return["order_id"])
    end

    def order_params _return
      Integration::Builder::OrderFromSf.new(order(_return)).build
    end

    def payment_params _return
      Integration::Builder::PaymentFromReturn.new(_return).build
    end
  end
end
