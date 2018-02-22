# File: queue.rb
# Time-stamp: <2018-02-22 13:27:47>
# Copyright (C) 2018 Pierre Lecocq
# Description: Queue example

require_relative '../lib/corelib'

puts "\n[Corelib::Queue] --"

# Enable module

Corelib.enable :queue

# Setup connection

queue = Corelib::Queue.connect :default,
                               host: ENV['QUEUE_HOST'],
                               port: ENV['QUEUE_PORT']

# Test worker
class TestWorker
  def self.handle(data = {})
    puts "[Corelib::Queue] -> Job consumed with message '#{data['message']}'"
  end
end

# Add job to a tube

tube_name = :test_tube

job = queue.push tube_name,
                 worker: 'TestWorker',
                 message: 'Hello'

puts "[Corelib::Queue] Adding job ##{job[:id]} in the #{tube_name} tube that returned: #{job[:status]}"

job = queue.push tube_name,
                 worker: 'TestWorker',
                 message: 'Bonjour'

puts "[Corelib::Queue] Adding job ##{job[:id]} in the #{tube_name} tube that returned: #{job[:status]}"

# Consume tube

puts "[Corelib::Queue] Consuming all the jobs in the #{tube_name} tube"

while (job = queue.pop(tube_name))
  queue.consume job
end

# Close connection

queue.close
