require_relative 'iot_client'

class PublisherManager
  def initialize(topic, options)
    @topic = topic
    @file_path, @log_id = options
  end

  def publish
    iot_client = IoTClient.new(log_id: @log_id)
    iot_client.publish(@topic, File.read(@file_path))
  end
end
