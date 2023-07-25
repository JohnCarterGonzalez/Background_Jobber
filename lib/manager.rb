require_relative 'cache'
require_relative 'worker'

module BackgroundJobber
  class Manager
    @cache = Cache::RedisWrapper.new
    @worker = Worker.new

    def self.blpoll(queue_name = 'default')
      loop do
        serialized_job = @cache.blpop(queue_name, 0).last
        @worker.work(serialized_job)
      end
    end
  end
end