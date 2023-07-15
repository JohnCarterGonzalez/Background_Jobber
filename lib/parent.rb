module BackgroundJobber
  class Parent
    def self.spawn_children(number_of_children)
      number_of_children.times do
        Child.new.spawn_worker
      end
    end
  end
end
