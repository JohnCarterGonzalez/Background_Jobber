require 'rspec'

require_relative 'backgroundjobber'

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

