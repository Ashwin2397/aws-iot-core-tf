require 'dotenv/load'
# Note:
# This monkey patch: https://github.com/njh/ruby-mqtt/blob/main/lib/mqtt/openssl_fix.rb
# is needed to prevent errors.
require 'mqtt'
require 'aws-sdk-ssm'

# Note:
# You need to add this line when running in the console for some reason:
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
# However, you do not need this in the script for some reason.
# In conclusion, you don't actually need SSL to fetch from the parameter store
# However, this is not a good practise.

class SSMRetriever
  class << self
    def retrieve(name)
      secrets_manager.get_parameter(name: name, with_decryption: true).parameter.value
    end

    def secrets_manager
      @secrets_manager ||= Aws::SSM::Client.new(
        region: ENV['AWS_REGION'],
        access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
      )
    end
  end
end

client = MQTT::Client.new(
  host: ENV['IOT_AWS_ENDPOINT'],
  ssl: true,
  port: 8883,
  cert: SSMRetriever.retrieve('certificate-pem'),
  key: SSMRetriever.retrieve('private-key'),
)

client.connect

# Example Publish
# client.publish('iot-core-topic', 'Some message')

# Subscribe
client.get('iot-core-topic') do |topic, message|
  File.write('output.png', message)
  puts 'Message Received!'
end

client.disconnect


