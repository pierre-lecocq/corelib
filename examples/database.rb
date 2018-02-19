# File: database.rb
# Time-stamp: <2018-02-15 12:08:17>
# Copyright (C) 2018 Pierre Lecocq
# Description: Database example

require_relative '../lib/corelib'

puts "\n[Corelib::Database] --"

# Enable module

Corelib.enable :database

# Setup connection

Corelib::Database.setup host: ENV['DB_HOST'],
                        dbname: ENV['DB_DBNAME'],
                        user: ENV['DB_USER'],
                        password: ENV['DB_PASSWORD']

# Check health

puts "[Corelib::Database] Is the server alive? #{Corelib::Database.alive?}"

# Execute a query

result = Corelib::Database.exec_params 'SELECT article_id FROM article WHERE article_id < $1', [2]
puts "[Corelib::Database] Executing a SELECT query that returns: #{result.res_status(result.result_status)}"

# Stats

print "[Corelib::Database] Get stats: "
p Corelib::Database.stats
