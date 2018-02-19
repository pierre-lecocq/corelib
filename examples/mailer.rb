# File: mailer.rb
# Time-stamp: <2018-02-13 21:21:58>
# Copyright (C) 2018 Pierre Lecocq
# Description: Mailer example

require_relative '../lib/corelib'

puts "\n[Corelib::Mailer] --"

# Enable module

Corelib.enable :mailer

# Setup connection

Corelib::Mailer.setup method: :test

# Send an email

Mail::TestMailer.deliveries

Corelib::Mailer.deliver 'toto@mail.com',
                        'titi@mail.com',
                        'Hello',
                        'Greetings'

puts "[Corelib::Mailer] #{Mail::TestMailer.deliveries.length} email(s) sent successfully"

Mail::TestMailer.deliveries.clear
