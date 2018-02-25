# File: mailer.rb
# Time-stamp: <2018-02-25 22:23:39>
# Copyright (C) 2018 Pierre Lecocq
# Description: Mailer class

module Corelib
  # Mailer class
  class Mailer
    include Validable

    # Setup the mail configureation
    #
    # @param config [Hash] Required keys: :method
    #
    # @raise [StandardError] if the configuration does not have all required keys
    def self.setup(config)
      raise_if_missing_keys config, :method

      config[:method] = config[:method].to_sym

      raise_if_missing_keys config, :address, :port if config[:method] == :smtp

      Mail.defaults do
        delivery_method(config[:method],
                        config.tap { |h| h.delete(:method) })
      end
    end

    # Deliver an email
    #
    # @param from [String]
    # @param to [String]
    # @param subject [String]
    # @param body [String]
    #
    # @return [Mail::Message]
    def self.deliver(from, to, subject, body)
      Mail.deliver do
        from from
        to to
        subject subject
        body body
      end
    end
  end
end
