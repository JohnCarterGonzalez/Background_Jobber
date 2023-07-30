require_relative 'backgroundjobber'

class JobTest 
  def perform(str)
    puts "test str, passed to redis, #{str}"
  end
end

# BackgroundJobber::Runner.run({class_name: JobTest, args: ["test string"]})
BackgroundJobber::Runner.run({class_name: "personal_details", args: ["John", "USA", "Happy"]})
