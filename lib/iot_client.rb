# Note:
# This monkey patch: https://github.com/njh/ruby-mqtt/blob/main/lib/mqtt/openssl_fix.rb
# is needed to prevent errors.
require 'mqtt'
require_relative './ssm_retriever'

class IoTClient
  attr_reader :client_id

  def initialize(log_id: '', client_id: SecureRandom.uuid)
    @log_id = log_id
    @client_id = client_id
  end

  def subscribe(topic)
    connect
    puts "IoT Client #{client_id} subscribed to: #{topic}"

    client.get(topic) do |_, message|
      log('receive')
      puts "Message received by #{client_id}!"
      File.write("./output/images/#{SecureRandom.uuid}_output.jpg", message)
    end
  end

  def unsubscribe
    client.disconnect
  end

  def publish(topic, message)
    connect
    log('publish')
    client.publish(topic, message)
    puts "Message published by #{client_id}!"
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
    puts "IoT Client #{client_id} connected!"
  end

  def log(action)
    File.write("./output/logs/output_#{@log_id}.log", "#{action},#{client_id},#{Time.now}\n", mode: 'a')
  end
end
