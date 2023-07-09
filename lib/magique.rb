# Create a pattern for the worker class, the perform method needs be defined in every implementation either on an instance of 
# class or the class itself using the perform_now method
module Magique 
  def self.backend
    @backend
  end

  def self.backend=(backend)
    @backend=backend
  end

  module Worker 
    def self.included(base) # callback for module inclusion, 'base' refers to the module that is including the Worker module
      base.extend(ClassMethods) #extends the base methods of the module with the ClassMethods module
    end

    module ClassMethods
      def perform_async(*args)
        Magique.backend.push(worker: self, args: args) # push to queue, instead of creating thread
      end
    end

    def perform(*)
      raise NotImplementedError
    end
  end

  class Processor
    # convenience method to check if threads are working
    def self.start(concurrency = 1)
      concurrency.times { |n| new("Processor #{n}") }
    end

    # each Processor creates a new thread that loops infinitely, every iteration it triues to grab
    # a new task from the queue, creates a new instance of the worker class and calls its perform method
    # with the given args
    def initialize(name)
      thread = Thread.new do
        perform_on_payload = new.perform(*payload[:args])        
        loop do
          payload = Magique.backend.pop
          worker_class = payload[:worker]
          worker_class.perform_on_payload
        end
      end

      thread.name = name
    end

  end

end

###### problem with run away threads, see Magique::Worker::ClassMethods perform_async
# implementing producer/consumer pattern via the class Queue for thread sync
# see self.backend
Magique.backend = Queue.new
Magique::Processor.start(5)
