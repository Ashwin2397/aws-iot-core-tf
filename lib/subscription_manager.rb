require_relative 'iot_client'

class SubscriptionManager
  def initialize(topic, options)
    @topic = topic
    @count, *@options = options
  end

  def subscribe
    threads = []
    (1..@count.to_i).each do |i|
      threads << Thread.new do
        iot_client = IoTClient.new(identifier: i)
        iot_client.subscribe(@topic)
      end 
    end

    threads.each(&:join)
  end
end
