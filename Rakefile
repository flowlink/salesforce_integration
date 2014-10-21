$stdout.sync = true

desc 'Open pry console'
task :console do
  require 'pry'
  require_relative 'lib/salesforce_integration'

  env_file = File.join File.expand_path('..', __FILE__), '.env'

  if File.exist? env_file
    require 'dotenv'
    Dotenv.load

    @client = Restforce.new(username:        ENV['SALESFORCE_USERNAME'],
                            password:        ENV['SALESFORCE_PASSWORD'],
                            security_token:  ENV['SALESFORCE_SECURITY_TOKEN'],
                            client_id:       ENV['SALESFORCE_CLIENT_ID'],
                            client_secret:   ENV['SALESFORCE_CLIENT_SECRET'])
  end

  def client
    @client
  end

  ARGV.clear
  Pry.start
end

