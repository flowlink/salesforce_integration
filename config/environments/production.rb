require 'rollbar'

class RequestDataExtractor
  include Rollbar::RequestDataExtractor
  def from_rack(env)
    extract_request_data_from_rack(env).merge({
      :route => env["PATH_INFO"]
    })
  end
end

Rollbar.configure do |config|
  config.access_token = '171244dd53c74f51a95d09e9a76056b0'
  config.environment = 'production'
end
