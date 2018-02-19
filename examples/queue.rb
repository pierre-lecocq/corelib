# File: queue.rb
# Time-stamp: <2018-02-13 21:22:13>
# Copyright (C) 2018 Pierre Lecocq
# Description: Queue example

require_relative '../lib/corelib'

puts "\n[Corelib::Queue] --"

# Enable module

Corelib.enable :queue

# Setup connection

Corelib::Queue.setup host: ENV['QUEUE_HOST'],
                     port: ENV['QUEUE_PORT']

# Test worker
class TestWorker
  def self.handle(data = {})
    puts "[Corelib::Queue] -> Job consumed with message '#{data['message']}'"
  end
end

# Add job to a tube

tube_name = :test_tube

job = Corelib::Queue.push tube_name,
                          worker: 'TestWorker',
                          message: 'Hello'

puts "[Corelib::Queue] Adding job ##{job[:id]} in the #{tube_name} tube that returned: #{job[:status]}"

job = Corelib::Queue.push tube_name,
                          worker: 'TestWorker',
                          message: 'Bonjour'

puts "[Corelib::Queue] Adding job ##{job[:id]} in the #{tube_name} tube that returned: #{job[:status]}"

# Consume tube

puts "[Corelib::Queue] Consuming all the jobs in the #{tube_name} tube"

while (job = Corelib::Queue.pop(tube_name))
  Corelib::Queue.consume job
end

# Close connection

Corelib::Queue.close
