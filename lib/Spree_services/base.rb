module SpreeService
  class Base

    attr_accessor :payload, :config, :service_name

    def initialize(service_name, payload, config)
      @payload = payload.is_a?(Array) ? payload.map(&:with_indifferent_access) : payload.with_indifferent_access
      @config = config
      @service_name = service_name
    end

    def handle_returns!
      Integration::Return.new(config, payload[service_name]).handle_all!
    end
  end
end
