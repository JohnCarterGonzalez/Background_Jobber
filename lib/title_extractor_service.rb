require 'open-uri'
require 'nokogiri'

require_relative 'magic'

class TitleExtractorWorker
  include Magic::Jobber

  
  def perform(url)
    document = Nokogiri::HTML(URI.open(url))
    title = document.css('html > head > title').first.content
    puts "#{title.gsub(/[[:space:]]+/, ' ').strip}"

  rescue
    puts "Unable to find a title for #{url}"
  end
end

RUBYMAGIC = [ "https://appsignal.com" ,"https://blog.appsignal.com/2023/07/11/boost-http-client-monitoring-in-elixir-with-appsignal-and-tesla-templates.html", "https://blog.appsignal.com/2023/06/28/keep-your-ruby-app-secure-with-bundler.html", "https://blog.appsignal.com/2023/06/21/an-introduction-to-lambdas-in-ruby.html"]


RUBYMAGIC.each { |url| TitleExtractorWorker.perform_now(url) }
