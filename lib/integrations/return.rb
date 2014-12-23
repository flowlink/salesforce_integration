module Integration
  class Return < Base
    attr_reader :object

    def initialize(config, object)
      @object = object
      super(config)
    end

    def upsert!
      attributes = Builder::Return.new(object[:return]).build
      return_service.upsert! attributes, object[:return]['order_id']
    end
  end
end
