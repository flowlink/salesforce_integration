module Integration
  class Shipment < Base
    attr_reader :object

    def initialize(config, object = {})
      @object = object
      super(config)
    end

    def upsert!
      opportunity = order_service.find(object[:shipment][:order_id])
      attributes = Builder::Shipment.new(object[:shipment]).build
      note_service.upsert! attributes, opportunity[:Id]

      custom_objects_upsert object[:shipment][:salesforce_custom].to_h
    end
  end

  module Builder
    class Shipment
      attr_reader :object

      def initialize(object)
        @object = object
      end

      # NOTE should probably set all Notes title in a single place through
      # the code base (payment, shipments, returns)
      def build
        params = {
          'Title'     => "Shipment # #{object['id']}",
          'Body'      => build_body(object),
          'IsPrivate' => false,
        }.merge Hash(object['note_custom_fields'])
      end

      def build_body(object)
        <<-body
Email: #{object['email']}
Status: #{object['status']}
Cost: #{object['cost']}
Shipping Method: #{object['shipping_method']}
Tracking: #{object['tracking']}
Items: #{object['items'].map { |i| i['name'] }.join(', ')}
        body
      end
    end
  end
end
