# File: queue_spec.rb
# Time-stamp: <2018-02-22 13:29:53>
# Copyright (C) 2018 Pierre Lecocq
# Description: Queue singleton class spec

require_relative '../lib/corelib'

Corelib.enable :queue

describe Corelib::Queue do
  before :all do
    Corelib::Queue.connect :default,
                           host: ENV['QUEUE_HOST'],
                           port: ENV['QUEUE_PORT']

    class TestWorker
      def self.handle(_data = {})
        true
      end
    end
  end

  after :all do
    Corelib::Queue.connection.close
  end

  describe '.setup' do
    it 'return a Beaneater instance' do
      expect(Corelib::Queue.connection.handler).to be_kind_of(Beaneater)
    end
  end

  describe '.push' do
    it 'push a job to a tube' do
      result = Corelib::Queue.connection.push :test_job,
                                              worker: 'TestWorker',
                                              message: 'Hello'

      job = Corelib::Queue.connection.jobs.find(result[:id])

      expect(result[:status]).to be == 'INSERTED'
      expect(job).to be_kind_of(Beaneater::Job)

      job.delete
    end
  end

  describe '.pop' do
    it 'pop a job from a tube' do
      result = Corelib::Queue.connection.push :test_job,
                                              worker: 'TestWorker',
                                              message: 'Hello'

      job = Corelib::Queue.connection.pop(:test_job)

      expect(job).to be_kind_of(Beaneater::Job)
      expect(job.id).to be == result[:id]

      job.delete
    end
  end

  describe '.consume' do
    it 'consume a job' do
      result = Corelib::Queue.connection.push :test_job,
                                              worker: 'TestWorker',
                                              message: 'Hello'

      Corelib::Queue.connection.consume Corelib::Queue.connection.pop(:test_job)

      expect(Corelib::Queue.connection.jobs.find(result[:id])).to be == nil
    end
  end
end
