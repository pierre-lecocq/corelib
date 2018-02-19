# File: cache.rb
# Time-stamp: <2018-02-13 23:36:44>
# Copyright (C) 2018 Pierre Lecocq
# Description: Cache example

require_relative '../lib/corelib'

puts "\n[Corelib::Cache] --"

# Enable module

Corelib.enable :cache

# Setup connection

Corelib::Cache.setup host: ENV['CACHE_HOST'],
                     port: ENV['CACHE_PORT']

# Check health

puts "[Corelib::Cache] Is the server alive? #{Corelib::Cache.alive?}"

# Set

key = "test:#{Time.now.to_i}"
puts "[Corelib::Cache] Setting key #{key} with value 'yes'"

Corelib::Cache.set key, 'yes'

# Get

value = Corelib::Cache.get key
puts "[Corelib::Cache] Getting key #{key} value: '#{value}'"

# Delete

Corelib::Cache.delete key

begin
  Corelib::Cache.get key
rescue Memcached::NotFound
  puts "[Corelib::Cache] Key #{key} has been deleted successfully"
end

# Stats

print "[Corelib::Cache] Get stats: "
p Corelib::Cache.stats
