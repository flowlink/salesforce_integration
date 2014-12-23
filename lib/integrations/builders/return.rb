module Integration
  module Builder
    class Return
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def build
        params = {
          'Title'     => "Return # #{object['id']}",
          'Body'      => build_body(object),
          'IsPrivate' => false
        }
      end

      def build_body(object)
        returned_items = object["inventory_units"].map{|item| item["variant"]["sku"]}
        returned_counts = returned_items.inject(Hash.new(0)) { |total, item| total[item] += 1; total }
        extra = "Returned items: "
        returned_counts.each { |item_name, count| extra += "#{item_name}: (#{count}) " }

        <<-body
Status: #{object['state']}
Amount: #{object['amount']}
#{extra}
        body
      end
    end
  end
end
