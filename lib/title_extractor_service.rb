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

TitleExtractorWorker.perform_now('https://appsignal.com') 