require_relative 'iot_client'

class SubscriptionManager
  def initialize(topic, options)
    @topic = topic
    @count = options.first.to_i
    @log_id = options[1]
  end

  def subscribe
    threads = []
    unsuccessful_subscribers = 0
    (1..@count).each do |i|
      threads << Thread.new do
        iot_client = IoTClient.new(log_id: @log_id, client_id: i)
        iot_client.subscribe(@topic)
      rescue StandardError
        unsuccessful_subscribers += 1
        puts "Subscriber #{i} errored out 😭"
      end 
    end

    # Wait till all subscribers are connected
    sleep(5)
    puts "#{@count - unsuccessful_subscribers}/#{@count} subscribers listening ..."

    threads.each(&:join)
  end
end
