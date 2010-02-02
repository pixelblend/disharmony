require 'net/http'
require 'uri'
require 'hpricot'
require 'htmlentities'
require 'chronic'

class Disharmony::Scraper
  attr_accessor :coder, :data, :net, :response, :html
  
  def initialize
    uri = URI.parse(Disharmony::Config['source_host'])
    Disharmony::Logger.info "connecting to #{uri.host}"

    self.net = Net::HTTP.new(uri.host, uri.port)
    self.coder = HTMLEntities.new
  end
  
  def latest
    self.connect("/#{Date.today.year}/")
    self.latest_show
  end
  
  def recent
    self.connect("/#{Date.today.year}/")
    self.posted_shows
  end
  
  def for_date(date)
    return false unless date.is_a?(Date)
    
    year  = date.strftime('%Y')
    month = date.strftime('%m')
    
    self.connect("/#{year}/archive/#{year}_#{month}_01_archive.html")
    self.posted_shows
  end
  
  protected
  def connect(path)
    Disharmony::Logger.info "connecting to #{path}" 

    self.response, self.data = self.net.get(path, nil)
    self.html = Hpricot(self.data)
  end
  
  def posted_shows
    self.scan_for_shows "div[@class='post'], h2[@class='date-header']"
  end
  
  def latest_show
    self.scan_for_shows "div[@class='post']:first, h2[@class='date-header']:first"
  end
  
  def scan_for_shows(selector)
    elements = self.html.search(selector)
    midpoint = elements.count/2-1
    
    #first set of elements are the posts
    posts  = elements[0..(midpoint)].to_a
    
    #and the second set are the header titles
    titles = elements[(midpoint+1)..(elements.count-1)].to_a
    
    Disharmony::Logger.info "#{midpoint} posts found"
    
    0.upto(midpoint).collect do |x|
      show = Disharmony::Show.new self.extract_show_information(posts[x], titles[x])
      show if show.save
    end.compact
  end
  
  def extract_show_information(post, title) 
    post_body = post.search('div.post-body').first.inner_html.gsub('<br />', "\n").gsub(/<\/?[^>]*>/, "").strip
    
    if post_body.match(/(Track List:)/i).nil?
      # no track list; just set blog post as listing. usually a pledge-drive show
      track_list = post_body
    else
      track_list = post_body.split(/(Track List:)/i)[2]
    end
    
    show_title = title.inner_html.strip.split(', ')[1..3].join(' ')
    show_date = Chronic.parse show_title
    
    Disharmony::Logger.info "Scraping info for #{show_title}"
    
    show_info = Hash.new
    
    show_info[:title]      = show_title
    show_info[:mp3]        = post.search('div.post-body a').first[:href]
    show_info[:track_list] = self.coder.decode track_list
    show_info[:status]     = :scraped
    show_info[:air_date]   = show_date
    
    show_info
  end
end
