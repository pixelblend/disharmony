class Disharmony
  attr_accessor :scraper, :shows

  def initialize(options={})
    self.scraper = Scraper.new
    self.shows   = Array.new
  end
  
  def download_latest
    # check for most recent show
    self.shows = self.scraper.latest
    
    # leech & tag 'em
    download_and_tag!
  end
  
  def download_recent(count=5)
    self.shows = self.scraper.recent(count)
    
    # leech & tag 'em
    download_and_tag!
  end

  private
  
  def download_and_tag!
    if self.shows.empty?
      Disharmony::Logger.info('No new shows found.')
      return false
    end

    self.shows = self.shows.collect do |show| 
      show = Leecher.new(show).download
      Tagger.tag!(show)
    end
  end
end
