module Integration
  module Builder
    class Contact

      attr_reader :object

      def initialize(object)
        @object = object.with_indifferent_access
      end

      def build
        params = {
          'FirstName' => customer_name('firstname'),
          'LastName'  => customer_name('lastname'),
          'Email'     => customer_email
        }.merge Hash(object['contact_custom_fields'])

        params.merge!(import_address_data('Mailing', shipping_address))
        params.merge!(import_address_data('Other', billing_address))
        params.merge!(import_phone_numbers)
      end

      private

      def import_phone_numbers
        {
          'Phone'      => shipping_address['phone'],
          'OtherPhone' => billing_address['phone']
        }
      end

      def import_address_data(type, data)
        {
          "#{type}Street"     => [data['address1'].to_s, data['address2'].to_s].reject(&:empty?).join(' '),
          "#{type}City"       => data['city'],
          "#{type}State"      => data['state'],
          "#{type}PostalCode" => data['zipcode'],
          "#{type}Country"    => data['country']
        }
      end

      def customer_email
        object['email']
      end

      def billing_address
        object['billing_address']
      end

      def shipping_address
        object['shipping_address']
      end

      def customer_name(type)
        return object[type] unless object[type].nil?
        billing_address[type].empty? ? shipping_address[type] : billing_address[type]
      end
    end
  end
end
