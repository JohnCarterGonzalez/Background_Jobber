# frozen_string_literal: true

module BackgroundJobber
  # Worker class, reponsible for creating the cache, and polling that
  # cache for jobs, picking them up and performing them

  class Worker
    def initialize
      @cache = Cache::RedisWrapper.new
    end

    def deserialize_job(job)
      ::YAML.load(job)
    end

    # continously checks for jobs in a queue by calling pop on the
    # cache obj, breaks if the queue is empty, if there are jobs
    # it deserializes the job_components, extracting the class and args
    # creates a new instance of the job class and calls perform passing the *args
    def work(serialized_job)
      components = deserialize_job(serialized_job)
      job_class, job_args = components.first, components.last
      Thread.new { job_class.new.perform(*job_args) }
    end
  end
end
