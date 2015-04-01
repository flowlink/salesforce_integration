module Integration
  module Builder
    class Account
      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        initial = address_data('Shipping', shipping_address).
          merge(address_data('Billing', billing_address)).
          merge('Name' => name, 'AccountNumber' => object['email']).
          merge(Hash(object['account_custom_fields']))

        if object['sf_record_type_id']
          initial.delete 'Name'

          initial.merge(
            'RecordTypeId' => object['sf_record_type_id'],
            'FirstName' => customer_name('firstname'),
            'LastName'  => customer_name('lastname'),
          )
        else
          initial
        end
      end

      private
      def address_data(type, data)
        {
          "#{type}Street"     => [data['address1'].to_s, data['address2'].to_s].reject(&:empty?).join(' '),
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
