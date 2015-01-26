module Integration
  module Builder
    class Account

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'Name' => name,
          'AccountNumber' => object['email'],
        }.merge(
          import_address_data('Shipping', shipping_address)
        ).merge(
          import_address_data('Billing', billing_address)
        ).merge Hash(object['account_custom_fields'])
      end

      private
      def import_address_data(type, data)
        {
          "#{type}Street"     => [data['address1'], data['address2']].reject(&:empty?).join(' '),
          "#{type}City"       => data['city'],
          "#{type}State"      => data['state'],
          "#{type}PostalCode" => data['zipcode'],
          "#{type}Country"    => data['country']
        }
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
