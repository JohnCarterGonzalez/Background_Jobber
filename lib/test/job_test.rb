# frozen_string_literal: true

require_relative '../app_test/job'

class JobTest
  include BackgroundJobber::Job

  def perform(str)
    puts "test string, to be passed: #{str}"
  end
end

JobTest.new.perform_async('hello world')
