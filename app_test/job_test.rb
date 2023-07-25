require_relative '../lib/job'

class JobTest
  include BackgroundJobber::Job

  def perform(str)
    puts "test str to be passed to redis, #{str}"
  end
end

JobTest.new.perform('hello world')