module Integration
  class Return < Base

    attr_reader :object

    def initialize(config, object)
      @object = object.map(&:with_indifferent_access)
      super(config)
    end

    def handle_all!
      @object.each { |_return| handle _return }
    end

    def handle _return
      return_service.upsert!(return_params(_return), _return['order_id'])
    end

    private

    def return_params _return
      Integration::Builder::Return.new(_return).build
    end
  end
end
