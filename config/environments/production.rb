Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_KEY']
  config.environment_name = ENV['RACK_ENV']
end
