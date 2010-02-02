class Disharmony
  attr_accessor :shows

  def initialize(options={})
    self.shows   = Array.new
  end
  
  def download_latest
    # check for most recent show
    self.shows = Scraper.new.latest
    
    # leech & tag 'em
    download_and_tag!
  end
  
  def download_recent
    self.shows = Scraper.new.recent
    
    # leech & tag 'em
    download_and_tag!
  end
  
  def download_for_date(date)
    self.shows = Scraper.new.for_date(date)
    
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
