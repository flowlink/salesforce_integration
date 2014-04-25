require 'pathname'

module App
  class << self
    def env
      ENV['APP_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def root
      Pathname.pwd
    end

    def endpoint_key
      return '123' if env == 'test'
      ENV['APP_ENDPOINT_KEY']
    end
  end
end
