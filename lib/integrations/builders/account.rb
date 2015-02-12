module Integration
  module Builder
    class Account

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Name' => name
        }.merge record_type_id
      end

      private
      def record_type_id
        if object['sf_record_type_id']
          { 'RecordTypeId' => object['sf_record_type_id'] }
        else
          {}
        end
      end

      def name
        "#{customer_name('firstname')} #{customer_name('lastname')}"
      end

      def customer_name(type)
        return object[type] unless object[type].nil?
        billing_address[type].empty? ? shipping_address[type] : billing_address[type]
      end

      def billing_address
        object['billing_address']
      end

      def shipping_address
        object['shipping_address']
      end
    end
  end
end
