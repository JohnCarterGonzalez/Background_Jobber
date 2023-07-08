require 'open-uri'
require 'nokogiri'

class TitleExtractorWorker
  include Magique::Worker

  
  def perform(url)
    document = Nokogiri::HTML(URI.open(url))
    title = document.css('html > head > title').first.content
    puts title.gsub(/[[:space:]]+/, ' ').strip

  rescue
    puts "Unable to find a title for #{url}"
  end
end

TitleExtractorWorker.perform_async('https://appsignal.com')
