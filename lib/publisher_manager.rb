require_relative 'iot_client'

class PublisherManager
  def initialize(topic, options)
    @topic = topic
    @file_path = options.first
  end

  def publish
    iot_client = IoTClient.new
    iot_client.publish(@topic, File.read(@file_path))
  end
end
