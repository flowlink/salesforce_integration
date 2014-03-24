require 'rollbar'

Rollbar.configure do |config|
  config.access_token = '171244dd53c74f51a95d09e9a76056b0'
  config.environment = 'production'
end
