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
    def poll(queue_name= 'default', child_process_id)
      loop do
        current_serialized_job = @cache.pop(queue_name)

        break if current_serialized_job.nil?
        current_job_components = deserialize_job(current_serialized_job)

        job_class = current_job_components.first
        job_args = current_job_components.last  
        p "hello from worker process #{child_process_id}"
        job_class.new.perform(*job_args)
      end
    end

  end
end