require 'dotenv/load'
require_relative './lib/subscription_manager'
require_relative './lib/iot_client'

subscribe_or_publish, *options = ARGV
case subscribe_or_publish
when 'subscribe'
  subscription_manager = SubscriptionManager.new('iot-core-topic', options)
  subscription_manager.subscribe
else
  iot_client = IoTClient.new
  iot_client.publish('iot-core-topic', File.read('example.png'))
end

