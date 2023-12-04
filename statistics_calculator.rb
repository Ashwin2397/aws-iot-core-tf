require 'terminal-table'
require 'date'

class StatisticsCalculator
  def initialize(n_subscribers)
    @n_subscribers = n_subscribers
  end

  def calculate
    table = Terminal::Table.new :headings => ['Id', 'Time Elapsed'], :rows => rows
    File.write(output_file, table.to_s + "\n\nAverage time elapsed: #{average_time_elapsed} seconds")
  end

  private

  def average_time_elapsed
    (rows.map(&:last).sum)/rows.size
  end

  def logs
    @logs ||= File.read("./output/logs/output_#{@n_subscribers}.log").split("\n").map { |l| l.split(',') }
  end

  def output_file
    "./output/statistics/time_elapsed_#{@n_subscribers}.txt"
  end

  def parsed_publish_time
    _, _, publish_time = publish_log
    @parsed_publish_time ||= DateTime.parse(publish_time)
  end

  def publish_log
    @publish_log ||= logs.find { |l| l.first == 'publish' }
  end

  def receive_logs
    logs.select { |l| l.first == 'receive' }
  end

  def rows
    @rows ||= receive_logs.map do |_, identifier, receipt_time|
      time_elapsed = DateTime.parse(receipt_time).to_time - parsed_publish_time.to_time
    
      [identifier, time_elapsed]
    end      
  end
end

n_subscribers = ARGV.first
StatisticsCalculator.new(n_subscribers).calculate
