# File: mailer_spec.rb
# Time-stamp: <2018-02-13 21:20:28>
# Copyright (C) 2018 Pierre Lecocq
# Description: Mailer spec

require_relative '../lib/corelib'

Corelib.enable :mailer

describe Corelib::Mailer do
  include Mail::Matchers

  before :all do
    Corelib::Mailer.setup method: :test
  end

  before :each do
    Mail::TestMailer.deliveries.clear
  end

  describe '.deliver' do
    it 'should send an email' do
      Corelib::Mailer.deliver 'toto@mail.com',
                              'titi@mail.com',
                              'Hello',
                              'Greetings'

      is_expected.to have_sent_email.from 'toto@mail.com'
      is_expected.to have_sent_email.to 'titi@mail.com'
      is_expected.to have_sent_email.with_subject 'Hello'
      is_expected.to have_sent_email.with_body 'Greetings'
    end
  end
end
