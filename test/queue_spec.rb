# File: queue_spec.rb
# Time-stamp: <2018-02-13 21:20:34>
# Copyright (C) 2018 Pierre Lecocq
# Description: Queue singleton class spec

require_relative '../lib/corelib'

Corelib.enable :queue

describe Corelib::Queue do
  before :all do
    Corelib::Queue.setup host: ENV['QUEUE_HOST'],
                         port: ENV['QUEUE_PORT']

    class TestWorker
      def self.handle(_data = {})
        true
      end
    end
  end

  after :all do
    Corelib::Queue.close
  end

  describe '.setup' do
    it 'return a Beaneater instance' do
      expect(Corelib::Queue.instance._connection).to be_kind_of(Beaneater)
    end
  end

  describe '.push' do
    it 'push a job to a tube' do
      result = Corelib::Queue.push :test_job,
                                   worker: 'TestWorker',
                                   message: 'Hello'

      job = Corelib::Queue.jobs.find(result[:id])

      expect(result[:status]).to be == 'INSERTED'
      expect(job).to be_kind_of(Beaneater::Job)

      job.delete
    end
  end

  describe '.pop' do
    it 'pop a job from a tube' do
      result = Corelib::Queue.push :test_job,
                                   worker: 'TestWorker',
                                   message: 'Hello'

      job = Corelib::Queue.pop(:test_job)

      expect(job).to be_kind_of(Beaneater::Job)
      expect(job.id).to be == result[:id]

      job.delete
    end
  end

  describe '.consume' do
    it 'consume a job' do
      result = Corelib::Queue.push :test_job,
                                   worker: 'TestWorker',
                                   message: 'Hello'

      Corelib::Queue.consume Corelib::Queue.pop(:test_job)

      expect(Corelib::Queue.jobs.find(result[:id])).to be == nil
    end
  end
end
