require 'yaml'
require 'pry-byebug'

require_relative 'job'
require_relative 'cache'
require_relative 'worker'

# entry into BackgroundJobber, going to be verbose in the comments because 
# this is me learning how a background system works, and I want to write my
# thought process out
module BackgroundJobber
  # Runner class, creates a job, using the opts params
  # with the class_name and args params, method calls
  # push on the job object, which adds the serialized job
  # to the cache 
  class Runner
    def self.run(options)
      job = Job.new(options[:classification], options[:args])
      job.push_to_cache

      worker = Worker.new
      worker.poll_for_jobs
    end
  end

end