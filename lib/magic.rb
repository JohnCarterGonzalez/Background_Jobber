module Magic
  module Jobber
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def perform_now(*args)
        new.perform(*args)
      end
    end

    def perform(*)
      raise NotImplementedError
    end
  end
end
