class Disharmony
  attr_accessor :scraper, :shows

  def initialize(options={})
    self.shows = Shows.new
    self.scraper = Scraper.new
  end

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
end

%w{show scraper leecher tagger}.each do |file|
  require File.join(File.dirname(__FILE__), file)
end

