require 'pathname'

module App
  class << self
    def env
      ENV['APP_ENV'] || 'development'
    end

    def root
      Pathname.pwd
    end

    def endpoint_key
      return '123' if env == 'test'
      ENV['APP_ENDPOINT_KEY']
    end

    def report_error(error)
      return unless env == 'production'
      Rollbar.report_exception(error)
    end
  end
end
