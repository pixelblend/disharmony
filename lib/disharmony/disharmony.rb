class Disharmony
  attr_accessor :leecher, :scraper, :shows

  def initialize(options={})
    self.leecher = Leecher.new
    self.scraper = Scraper.new
    self.shows   = Array.new
  end
  
  def download_latest
    # check for most recent show
    self.shows = self.scraper.latest
    return false if self.shows.empty?
    # leech & tag 'em
    self.download_and_tag!
  end

  private
  
  def download_and_tag!
    self.shows = self.shows.collect do |show| 
      show = self.leecher.download(show)
      Disharmony::Tagger.tag!(show)
    end
  end
  
=begin    
  def scrape_latest_shows
    self.shows.latest = self.scraper.latest_shows
  end

  def download_show(id=1)
    active_download = self.shows.latest[id]
    raise "Selected show #{id} could not be found" if active_download.nil?
     
    archive = self.scraper.download_show(active_download)
    mp3 = self.extract!(archive)
    self.tag_show(mp3)
    self.shows.log_downloaded(active_download)
  end
=end
end
