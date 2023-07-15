require 'rspec'

require_relative 'backgroundjobber'

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