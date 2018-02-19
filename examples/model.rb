# File: model.rb
# Time-stamp: <2018-02-19 23:48:05>
# Copyright (C) 2018 Pierre Lecocq
# Description: Model example

require_relative '../lib/corelib'

puts "\n[Corelib::Model] --"

# Enable module

Corelib.enable :model

# Setup connection

Corelib::Database.setup host: ENV['DB_HOST'],
                        dbname: ENV['DB_DBNAME'],
                        user: ENV['DB_USER'],
                        password: ENV['DB_PASSWORD']

# Setup log

Corelib::Log.setup

# Set model

class Article < Corelib::Model
  include Corelib::Loggable # Comment this to avoid logs

  schema :article,
         article_id:    { primary_key: true, formatter: :to_i },
         title:         {},
         state:         { type: Integer }
end

# Create

a = Article.create title: 'Hello',
                   state: 0

puts "[Corelib::Model] Create an instance of a model: #{a.class}:#{a.object_id}"

# Update

old = a.title
a.update title: 'Bonjour',
         state: 2

puts "[Corelib::Model] Update the title property from '#{old}' to '#{a.title}'"

# Delete

a.delete

begin
  a.title
rescue NoMethodError
  puts '[Corelib::Model] Object has been deleted successfully'
end
