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
