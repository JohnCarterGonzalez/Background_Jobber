require 'rspec'

require_relative 'backgroundjobber'

RSpec.describe BackgroundJobber::Runner do
  describe '.run' do
    let(:job) { instance_double(BackgroundJobber::Job) }
    let(:worker) { instance_double(BackgroundJobber::Worker) }

    before do
      allow(BackgroundJobber::Job).to receive(:new).and_return(job)
      allow(BackgroundJobber::Worker).to receive(:new).and_return(worker)
      allow(job).to receive(:push_to_cache)
      allow(worker).to receive(:poll)
    end

    it 'creates a job and pushes it to the cache' do
      opts = { class_name: 'MyJob', args: ["banana"] }

      expect(BackgroundJobber::Job).to receive(:new).with(opts[:class_name], opts[:args])
      expect(job).to receive(:push_to_cache)

      described_class.run(opts)
    end

    it 'creates a worker and starts polling' do
      expect(BackgroundJobber::Worker).to receive(:new).and_return(worker)
      expect(worker).to receive(:poll)

      described_class.run({})
    end
  end
end

RSpec.describe BackgroundJobber::Job do
  describe '#serialize_the_obj' do
    it 'serializes the object correctly' do
      job = BackgroundJobber::Job.new('MyJob', [1, 2, 3])
      expect(job.serialize_the_obj).to eq("---\n- MyJob\n- - 1\n  - 2\n  - 3\n")
    end
  end

  describe '#push_to_cache' do
    let(:cache) { instance_double(BackgroundJobber::Cache::RedisWrapper) }

    before do
      allow(BackgroundJobber::Cache::RedisWrapper).to receive(:new).and_return(cache)
      allow(cache).to receive(:push)
    end

    it 'pushes the serialized object to the cache' do
      job = BackgroundJobber::Job.new('MyJob', [1, 2, 3])
      expect(cache).to receive(:push).with('default', job.serialize_the_obj)
      job.push_to_cache
    end

    it 'pushes the serialized object to the specified queue' do
      job = BackgroundJobber::Job.new('MyJob', [1, 2, 3])
      expect(cache).to receive(:push).with('my_queue', job.serialize_the_obj)
      job.push_to_cache('my_queue')
    end
  end
end



RSpec.describe BackgroundJobber::Cache::RedisWrapper do
  let(:redis) { instance_double(Redis) }

  before do
    allow(Redis).to receive(:new).and_return(redis)
    allow(redis).to receive(:lpop)
    allow(redis).to receive(:rpush)
    allow(redis).to receive(:flushdb)
  end

  describe '#pop' do
    it 'pops the first value from the list' do
      expect(redis).to receive(:lpop).with('my_key')
      described_class.new(redis).pop('my_key')
    end
  end

  describe '#push' do
    it 'pushes the value to the end of the list' do
      expect(redis).to receive(:rpush).with('my_key', 'my_value')
      described_class.new(redis).push('my_key', 'my_value')
    end
  end

  describe '#flush' do
    it 'flushes the Redis database' do
      expect(redis).to receive(:flushdb)
      described_class.new(redis).flush
    end
  end
end

RSpec.describe BackgroundJobber::Worker do
  let(:cache) { instance_double(BackgroundJobber::Cache::RedisWrapper) }

  before do
    allow(BackgroundJobber::Cache::RedisWrapper).to receive(:new).and_return(cache)
    allow(cache).to receive(:pop).and_return(nil)
  end

  describe '#deserialize_job' do
    it 'deserializes a YAML string into an object' do
      job = ['MyJob', [1, 2, 3]]
      serialized_job = "---\n- MyJob\n- - 1\n  - 2\n  - 3\n"
      expect(described_class.new.deserialize_job(serialized_job)).to eq(job)
    end
  end

  describe '#poll' do
    let(:job_class) { instance_double('MyJob') }
    let(:job_instance) { instance_double('MyJob', perform: nil) }

    before do
      allow(job_class).to receive(:new).and_return(job_instance)
      allow(cache).to receive(:pop).and_return("---\n- MyJob\n- - 1\n  - 2\n  - 3\n")
    end

    it 'polls the cache for jobs and performs them' do
      expect(cache).to receive(:pop).with('default').and_return("---\n- MyJob\n- - 1\n  - 2\n  - 3\n")
      expect(job_class).to receive(:new).with(1, 2, 3).and_return(job_instance)
      expect(job_instance).to receive(:perform)
      described_class.new.poll('default')
    end

    it 'stops polling when the queue is empty' do
      expect(cache).to receive(:pop).with('default').and_return(nil)
      described_class.new.poll('default')
    end
  end
end