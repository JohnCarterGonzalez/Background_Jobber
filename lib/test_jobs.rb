class TestJobs
  def initialize
  end

  # These methods are for testing purposes to ensure that workers can
  # complete a variety of jobs.

  def hello_world
    puts "Hello World!"
  end

  def my_name_is(name)
    puts "My name is #{name}"
  end

  def my_name_is_and_i_am(name, age)
    puts "My name is #{name} and I am #{age} years old"
  end

  def i_am_from(country)
    puts "I am from #{country}"
  end

  def i_am_feeling(feeling)
    puts "I am feeling #{feeling}"
  end

end
