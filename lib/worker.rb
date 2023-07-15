module BackgroundJobber 

  # Worker class, reponsible for creating the cache, and polling that 
  # cache for jobs, picking them up and performing them

  class Worker
    def initialize
      @cache = Cache::RedisWrapper.new
    end

    def deserialize_job(job)
      ::YAML.unsafe_load(job)
    end

    # continously checks for jobs in a queue by calling pop on the
    # cache obj, breaks if the queue is empty, if there are jobs
    # it deserializes the job_components, extracting the class and args
    # creates a new instance of the job class and calls perform passing the *args
    def poll(queue_name= 'default')
      loop do
        current_serialized_job = @cache.pop(queue_name)

        break if current_serialized_job.nil?
          # rewrote this section of code to make it slightly more readable and testable.
          # I also added a check to see if the job is an array, if it is, it passes the args
          # as an array, if not, it passes the args as a single arg
        class_name, args = deserialize_job(job)
        job_class = Object.const_get(class_name)
        job_args = args.is_a?(Array) ? args : [args]  
        
        job_class.new.perform(*job_args)
      end
    end

  end
end