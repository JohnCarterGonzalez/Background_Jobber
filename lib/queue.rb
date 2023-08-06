# frozen_string_literal: true

require_relative 'cache'

module BackgroundJobber 
  class Queue
    @cache = Cache::RedisWrapper.new

    def self.enqueue(queue_name = 'default', serialized_job)
      @cache.push(queue_name, serialized_job)
    end
  end
end
