# frozen_string_literal: true

module BackgroundJobber

# part of the BackGround Job module, this inits the Job class which 
# is responsible for serializing and pushing the job to the cache 
# RedisWrapper
  class Job
    def initialize(classification, args)
      @classification = classification
      @args = args
      @cache = Cache::RedisWrapper.new
    end

# Serializes the ruby object into a YAML string
    def serialize_the_obj
      job_obj = [@classification, @args]
      YAML.dump(job_obj)
    end

# Pushes the serialized object to the cache
    def push_to_cache(queue_name = 'default')
      @cache.push(queue_name, serialize_the_obj)
    end

  end

end