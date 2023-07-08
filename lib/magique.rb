# Create a pattern for the worker class, the perform method needs be defined in every implementation either on an instance of 
# class or the class itself using the perform_now method
module Magique 
  module Worker 
    def self.included(base) # callback for module inclusion, 'base' refers to the module that is including the Worker module
      base.extend(ClassMethods) #extends the base methods of the module with the ClassMethods module
    end

    module ClassMethods
      def perform_async(*args)
        Thread.new { new.perform(*args) }
      end
    end

    def perform(*)
      raise NotImplementedError
    end
  end
end
