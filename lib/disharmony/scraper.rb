require 'net/http'
require 'uri'
require 'hpricot'
require 'htmlentities'
require 'chronic'

class Disharmony::Scraper
  attr_accessor :coder, :data, :net, :response, :html, :url, :year
  
  def initialize(year=Date.today.year)
    self.year = year
    uri = URI.parse(Disharmony::Config['source_host'])
    Disharmony::Logger.info "connecting to #{uri.host}"

    self.net = Net::HTTP.new(uri.host, uri.port)
    self.coder = HTMLEntities.new
  end
  
  def latest
    self.connect("/#{self.year}/")
    self.latest_show
  end

  def recent(count)
    count = 1 if count.to_i < 1
    
    self.connect("/#{self.year}/")
    self.recent_shows(count)
  end
  
  def for_date(date)
    year  = date.strftime('%Y')
    month = date.strftime('%m')
    
    self.connect("/#{year}/#{year}_#{month}_01_archive.html")
    self.posted_shows
  end
  
  protected
  def connect(path)
    Disharmony::Logger.info "connecting to #{path}" 

    self.response, self.data = self.net.get(path, nil)
    self.html = Hpricot(self.data)
  end
  
  def posted_shows
    self.scan_for_shows ""
  end
  
  def recent_shows(count)
    self.scan_for_shows "//ul[@id='recently'] li:nth-child(-n+#{count}) a"
  end
  
  def latest_show
    self.scan_for_shows "//ul[@id='recently'] li:first-child a"
  end
  
  def scan_for_shows(selector)
    self.html.search(selector).collect do |link|
      show = Disharmony::Show.new self.extract_show_information(link[:href].gsub("#{self.url}",''))
      
      show if show.save
    end.compact
  end
  
  def extract_show_information(url)
    self.connect(url)
    
    post_body = self.html.search('div.post-body').first.inner_html.gsub('<br />', "\n").gsub(/<\/?[^>]*>/, "").strip
    
    if post_body.match(/(Track List:)/i).nil?
      # no track list; just set blog post as listing. usually a pledge-drive show
      track_list = post_body
    else
      track_list = post_body.split(/(Track List:)/i)[2]
    end
    
    show_title = html.search('h2.date-header').inner_html.strip.split(', ')[1..3].join(' ')
    show_date = Chronic.parse show_title
    
    show_info = Hash.new
    
    show_info[:title]      = show_title
    show_info[:mp3]        = html.search('div.post-body a').first[:href]
    show_info[:track_list] = self.coder.decode track_list
    show_info[:status]     = :scraped
    show_info[:air_date]   = show_date
    
    show_info
  end
end
