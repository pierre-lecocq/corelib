# File: queue.rb
# Time-stamp: <2018-02-13 21:19:43>
# Copyright (C) 2018 Pierre Lecocq
# Description: Queue singleton class

module Corelib
  # Queue singleton class
  class Queue
    include Singleton

    # Connection accessors
    # @!visibility private
    attr_accessor :_connection

    # Setup the beanstalk connection
    #
    # @param config [Hash] Required keys: :host, :port
    #
    # @raise [StandardError] if the configuration does not have all required keys
    def self.setup(config)
      keys = %i[host port]

      raise "Invalid database config. It must include #{keys.join ', '}" \
        unless keys.all?(&config.method(:key?))

      instance._connection = ::Beaneater.new "#{config[:host]}:#{config[:port]}"
    end

    # Close the current connection
    def self.close
      instance._connection.close
    end

    # Get jobs list
    #
    # @return [Jobs]
    def self.jobs
      instance._connection.jobs
    end

    # Push a job into a named tube
    #
    # @param tube_name [String, Symbol]
    # @params data [Hash]
    def self.push(tube_name, data = {}, options = {})
      raise 'Job data must include a :worker entry with a class name' \
        unless data.key? :worker

      # Kernel will raise a NameError exception if the class does not exist
      klass = Kernel.const_get(data[:worker])

      raise "Worker class #{data[:worker]} must include a class method named 'handle'" \
        unless klass.respond_to? :handle

      tube = instance._connection.tubes[tube_name.to_s]
      tube.put data.to_json, options
    end

    # Pop a named tube
    #
    # @param tube_name [Symbol]
    def self.pop(tube_name)
      tube = instance._connection.tubes[tube_name.to_s]
      return nil unless tube.peek :ready

      tube.reserve
    end

    # Consume a job
    #
    # @param job [Beaneater::Job]
    def self.consume(job)
      data = JSON.parse(job.body)
      worker = data['worker']
      data = data.tap { |h| h.delete('worker') }

      Kernel.const_get(worker).send :handle, data

      job.delete
    end
  end
end
