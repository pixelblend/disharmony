require 'net/http'
require 'uri'
require 'nokogiri'
require 'htmlentities'

class Disharmony::Scraper
  attr_accessor :coder, :data, :net, :response, :html
  
  def initialize
    uri = URI.parse(Disharmony::Config['source_host'])
    Disharmony::Logger.info "connecting to #{uri.host}"

    self.net = Net::HTTP.new(uri.host, uri.port)
    self.coder = HTMLEntities.new
  end
  
  def latest
    self.connect("/.feed")
    self.latest_show
  end
  
  def recent
    self.for_date(Date.today)    
  end
  
  def for_date(date)
    return false unless date.is_a?(Date)
    
    year  = date.strftime('%Y')
    month = date.strftime('%B').downcase
    
    self.connect("/#{year}/#{month}-#{year}.feed")
    self.posted_shows
  end
  
  protected
  def connect(path)
    Disharmony::Logger.info "connecting to #{path}" 

    self.response, self.data = self.net.get(path, nil)
    self.html = Nokogiri::HTML(self.data)
  end
  
  def posted_shows
    self.scan_for_shows "item"
  end
  
  def latest_show
    self.scan_for_shows "item:first"
  end
  
  def scan_for_shows(selector)
    self.html.search(selector).collect do |post|
      attributes = self.extract_show_information(post)
      
      show   = Disharmony::Show.find_scraped(attributes[:title])
      show ||= Disharmony::Show.new(attributes)
      
      show if show.scraped!
    end.compact
  end
  
  def extract_show_information(post) 
    show_date  = Date.parse post.search('pubdate').first.content
    show_title = show_date.strftime('%d %B %Y')
    
    Disharmony::Logger.info "Scraping info for #{show_title}"
    
    show_info = Hash.new
    
    show_info[:title]      = show_title
    show_info[:track_list] = extract_track_list_from_post(post)
    show_info[:mp3]        = extract_zips_from_post(post)
    show_info[:air_date]   = show_date
    
    show_info
  end
  
  def extract_track_list_from_post(post)
    track_list = post.search('description *').children.collect do |txt|
      next unless txt.text?
      next txt.content.strip unless txt.content.strip.match(/^(\d){1,2}\./).nil?
    end.compact.join("\n")
    self.coder.decode track_list
  end  
  
  def extract_zips_from_post(post)
    show_zips = Array.new

    post.search('description').first.children.search('a').collect do |link|
      show_zips << link[:href] if link[:href].include?('.zip')
    end
    
    show_zips.uniq!
    
    case show_zips.size
      when 0
        ''
      when 1
        show_zips.first
      else
        show_zips.join('|')
    end
  end
end
