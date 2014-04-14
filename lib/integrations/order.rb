module Integration
  class Order < Base

    attr_reader :object

    def initialize(config, object)
      @object = object.with_indifferent_access
      super(config)
    end

    def upsert!
      create_contact
      create_order
    end

    def create_contact
      Integration::ContactAccount.new(config, contact_attributes).upsert!
    end

    def create_order
      order_service.upsert!(order_params)
    end

    private

    def order_params
      Integration::Builder::Order.new(object['order']).build
    end

    def contact_attributes
      {
        'firstname'        => first_name,
        'lastname'         => last_name,
        'email'            => email,
        'shipping_address' => shipping_address,
        'billing_address'  => billing_address,
      }
    end

    def first_name
      shipping_address['firstname'] || billing_address['firstname']
    end

    def last_name
      shipping_address['lastname'] || billing_address['lastname']
    end

    def email
      lookup_item('email')
    end

    def billing_address
      lookup_item('billing_address')
    end

    def shipping_address
      lookup_item('shipping_address')
    end

    private

    def lookup_item(item)
      object['order'].fetch item
    end

  end
end
