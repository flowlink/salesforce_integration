require 'pathname'

module App
  class << self
    def env
      ENV['APP_ENV'] || 'development'
    end

    def root
      Pathname.pwd
    end
  end
end
