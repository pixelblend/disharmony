require 'hpricot'
require 'htmlentities'
require 'chronic'

class Disharmony::Scraper
  attr_accessor :coder, :data, :net, :results, :response, :show_info, :url, :year
  
  def initialize(year=Date.today.year)
    self.year = year
    uri = URI.parse(Disharmony::Options[:source_host])

    self.net = Net::HTTP.new(uri.host, uri.port)
    self.coder = HTMLEntities.new
  end
  
  def latest
    self.prepare_to_scrape!
    self.connect("/#{self.year}/")
    html = Hpricot(self.data)
    html.search("//ul[@id='recently'] li a").collect do |show|
      Show.new self.extract_show_information(show[:href].gsub("#{self.url}",''))
    end
  end
  
  protected

  def prepare_to_scrape!
    self.response = nil
    self.data = nil
    self.results = Array.new
  end
  
  def connect(path)
    self.response, self.data = self.net.get(path, nil)
  end
  
  def extract_show_information(url)
    self.connect(url)
    html = Hpricot(self.data)
    
    track_list = html.search('div.post-body').first.inner_html.gsub('<br />', "\n\r").gsub(/<\/?[^>]*>/, "").split(/(Track List:)/i)[1..2].join("\n").strip
    
    show_info = Hash.new
    
    show_info[:title]      = html.search('h2.date-header').inner_html.strip
    show_info[:zip]        = html.search('div.post-body a').first[:href]
    show_info[:track_list] = self.coder.decode track_list
    
    show_info
  end
end
