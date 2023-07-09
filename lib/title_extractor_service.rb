require 'open-uri'
require 'nokogiri'

require_relative 'magique'

class TitleExtractorWorker
  include Magique::Worker

  
  def perform(url)
    document = Nokogiri::HTML(URI.open(url))
    title = document.css('html > head > title').first.content
    puts "[#{Thread.current.name}] #{title.gsub(/[[:space:]]+/, ' ').strip}"

  rescue
    puts "Unable to find a title for #{url}"
  end
end

TitleExtractorWorker.perform_async('https://appsignal.com') 