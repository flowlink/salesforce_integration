module Integration
  class Return < Base
    attr_reader :object

    def initialize(config, object)
      @object = object
      super(config)
    end

    def upsert!
      opportunity = order_service.find(object[:return][:order_id])
      attributes = Builder::Return.new(object[:return]).build
      note_service.upsert! attributes, opportunity[:Id]
    end
  end
end
