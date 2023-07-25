require 'yaml'
require 'pry-byebug'

require_relative 'job'
require_relative 'cache'
require_relative 'worker'
require_relative 'manager'
require_relative '../app_test/job_test'


# entry into BackgroundJobber, going to be verbose in the comments because 
# this is me learning how a background system works, and I want to write my
# thought process out
BackgroundJobber::Parent.blpoll
module BackgroundJobber
end