# frozen_string_literal: true

require_relative 'cache'
require_relative 'worker'

module BackgroundJobber
  class Manager
    @cache = Cache::RedisWrapper.new
    @worker = Worker.new

    def self.poll(queue_name = 'default')
      loop do
        serialized_job = @cache.pop(queue_name, 0).last
        @worker.work(serialized_job)
      end
    end
  end
end
