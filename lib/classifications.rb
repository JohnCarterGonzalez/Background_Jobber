# reference to the test_jobs.rb file
require_relative 'test_jobs.rb'

# Premade Classifications for testing purposes

class Classifications

  def self.personal_details(name, country, feeling)
    @test_jobs = TestJobs.new
    @test_jobs.my_name_is(name)
    @test_jobs.i_am_from(country)
    @test_jobs.i_am_feeling(feeling)
  end
end
