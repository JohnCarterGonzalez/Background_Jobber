# frozen_string_literal: true

module BackgroundJobber

# part of the BackGround Job module, this inits the Job class which 
# is responsible for serializing and pushing the job to the cache 
# RedisWrapper
  class Job
    def initialize(class_name, args)
      @class_name = class_name
      @args = args
      @cache = Cache::RedisWrapper.new
    end


    def serialize_the_obj
      job_obj = [@class_name, @args]::YAML.dump(job_obj)
    end


    def push_to_cache(queue_name = 'default')
      @cache.push(queue_name, serialize_the_obj)
    end

  end

end