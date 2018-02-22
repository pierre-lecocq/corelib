# File: cache.rb
# Time-stamp: <2018-02-22 12:37:21>
# Copyright (C) 2018 Pierre Lecocq
# Description: Cache example

require_relative '../lib/corelib'

puts "\n[Corelib::Cache] --"

# Enable module

Corelib.enable :cache

# Setup connection

cache = Corelib::Cache.connect :default,
                               host: ENV['CACHE_HOST'],
                               port: ENV['CACHE_PORT']

# Check health

puts "[Corelib::Cache] Is the server alive? #{cache.alive?}"

# Set

key = "test:#{Time.now.to_i}"
puts "[Corelib::Cache] Setting key #{key} with value 'yes'"

cache.set key, 'yes'

# Get

value = cache.get key
puts "[Corelib::Cache] Getting key #{key} value: '#{value}'"

# Delete

cache.delete key

begin
  cache.get key
rescue Memcached::NotFound
  puts "[Corelib::Cache] Key #{key} has been deleted successfully"
end

# Stats

print "[Corelib::Cache] Get stats: "
p cache.stats
