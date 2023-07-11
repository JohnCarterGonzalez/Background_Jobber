module Magic
  module Jobber
    def self.included(base)
      base.extend(ClassMethods)
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
