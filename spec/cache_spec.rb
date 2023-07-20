require 'rspec'

require_relative 'backgroundjobber'

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