# Note:
# This monkey patch: https://github.com/njh/ruby-mqtt/blob/main/lib/mqtt/openssl_fix.rb
# is needed to prevent errors.
require 'mqtt'
require_relative './ssm_retriever'

class IoTClient
  attr_reader :identifier

  def initialize(identifier: SecureRandom.uuid)
    @identifier = identifier
  end

  def subscribe(topic)
    connect
    puts "IoT Client #{identifier} subscribed to: #{topic}"

    client.get(topic) do |_, message|
      log('receive')
      puts "Message received by #{identifier}!"
      File.write("./output/#{SecureRandom.uuid}_output.png", message)
    end
  end

  def unsubscribe
    client.disconnect
  end

  def publish(topic, message)
    connect
    client.publish(topic, message)
    log('publish')
    puts "Message published by #{identifier}!"
  end

  private

  def client
    @client ||= MQTT::Client.new(
      host: ENV['IOT_AWS_ENDPOINT'],
      ssl: true,
      port: 8883,
      cert: SSMRetriever.retrieve('certificate-pem'),
      key: SSMRetriever.retrieve('private-key'),
    )
  end

  def connect
    client.connect
    puts "IoT Client #{identifier} connected!"
  end

  def log(action)
    File.write('output.log', "#{action},#{identifier},#{Time.now}\n", mode: 'a')
  end
end
