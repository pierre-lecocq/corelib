# File: mailer.rb
# Time-stamp: <2018-02-13 21:19:35>
# Copyright (C) 2018 Pierre Lecocq
# Description: Mailer class

module Corelib
  # Mailer class
  class Mailer
    # Setup the mail configureation
    #
    # @param config [Hash] Required keys: :method
    #
    # @raise [StandardError] if the configuration does not have all required keys
    def self.setup(config)
      raise "Invalid mailer config. It must include ':method'" unless config.key? :method

      config[:method] = config[:method].to_sym

      case config[:method]
      when :smtp
        keys = %i[address port]
      when :logger, :test
        keys = nil
      else
        raise "Invalid mailer config. Unknown method '#{config[:method]}'"
      end

      unless keys.nil?
        raise "Invalid mailer config. It must include #{keys.join ', '}" \
          unless keys.all?(&config.method(:key?))
      end

      Mail.defaults do
        delivery_method(config[:method].to_sym,
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
