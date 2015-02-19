$stdout.sync = true

require 'bundler'
Bundler.require(:default)

desc 'Open pry console'
task :console do
  require 'pry'
  require_relative 'lib/salesforce_integration'

  env_file = File.join File.expand_path('..', __FILE__), '.env'

  if File.exist? env_file
    require 'dotenv'
    Dotenv.load

    @client = Restforce.new(
      instance_url:    ENV['SALESFORCE_INSTANCE_URL'],
      oauth_token:     ENV['SALESFORCE_ACCESS_TOKEN'],
      refresh_token:   ENV['SALESFORCE_REFRESH_TOKEN'],
      client_id:       ENV['SALESFORCE_CLIENT_ID'],
      client_secret:   ENV['SALESFORCE_CLIENT_SECRET']
    )
  end

  def client
    @client
  end

  ARGV.clear
  Pry.start
end
