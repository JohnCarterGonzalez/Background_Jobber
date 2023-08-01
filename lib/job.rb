# frozen_string_literal: true

require_relative 'queue'
require 'yaml'

module BackgroundJobber
  # part of the BackGround Job module, this inits the Job class which
  # is responsible for serializing and pushing the job to the cache
  # RedisWrapper
  class Job
    def perform_async(*args)
      Queue.enqueue(serialized(self.class, args))
    end
    
    def serialize_the_obj(class_name, args)
      job_obj = [@class_name, @args]
      ::YAML.dump(job_obj)
    end

  end
end
