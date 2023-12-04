require 'dotenv/load'
require_relative './lib/subscription_manager'
require_relative './lib/publisher_manager'

subscribe_or_publish, *options = ARGV
case subscribe_or_publish
when 'subscribe'
  subscription_manager = SubscriptionManager.new('iot-core-topic', options)
  subscription_manager.subscribe
else
  publisher_manager = PublisherManager.new('iot-core-topic', options)
  publisher_manager.publish
end

