require 'hpricot'
require 'net/http'
require 'uri'
require 'htmlentities'
require 'zip/zip'
require 'zip/zipfilesystem'
require 'id3lib'
require 'chronic'

class Disharmony::Scraper
  attr_accessor :coder, :data, :net, :results, :response, :show_info, :url, :year
  
  def initialize(year=Date.today.year)
    self.year = year
    self.url  = "http://rollins-archive.com"
    uri = URI.parse(self.url)

    self.net = Net::HTTP.new(uri.host, uri.port)
    self.coder = HTMLEntities.new
  end
  
  def latest_shows
    self.prepare_to_scrape!
    self.connect("/#{self.year}/")
    html = Hpricot(self.data)
    html.search("//ul[@id='recently'] li a").collect do |show|
      {:title => show.inner_html, :url => show[:href].gsub("#{self.url}",'')}
    end
  end
  
  def download_show(show)
    self.show_info = Hash.new
    extract_show_information(show[:url])
    # self.connect(self.show_info[:zip])
    
    uri = URI.parse('http://rumble.dev')
    self.response, self.data = Net::HTTP.new(uri.host, uri.port).get('/test.zip', nil)
    
    
    # write zip to temp directory
    file_name = self.show_info[:title].downcase.gsub(' ', '_').gsub(/[^\w\d]/, '')
    file_path = File.join(File.dirname(__FILE__), '..', 'shows', 'tmp')
    
    zip_path = File.join(file_path, file_name+'.zip')
    mp3_path = File.join(file_path, file_name+'.mp3')
    
    File::open(zip_path, "wb+") do |zip_file|
      zip_file.write(self.data)
    end
    
    Zip::ZipFile.open(zip_path) do |zip_file|
      case zip_file.entries.size
      when 1
        zip_file.entries.first.extract(mp3_path)
        self.tag_show(mp3_path)
      else
        raise "Don't know how to handle #{zip_file.entries.size} files in a zip"
      end
    end
    File.unlink(zip_path)
    File.unlink(mp3_path)
  end
  
  
  def tag_show(mp3)
    tag = ID3Lib::Tag.new(mp3, ID3Lib::V2)
    tag.artist = 'Harmony In My Head'
    tag.album = 'Harmony In My Head'
    tag.band = 'Henry Rollins'
    tag.track = '1'
    tag.content_type = 'Podcast'
    tag.lyrics = self.show_info[:track_list]
    tag.title = self.show_info[:title]
    tag.set_frame_text :PCST, '1'
    tag.set_frame_text :TDES, tag.lyrics
    tag.update!
    debugger
    1+1

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
    
    self.show_info[:title]      = html.search('h2.date-header').inner_html.strip
    self.show_info[:zip]        = html.search('div.post-body a').first[:href]
    self.show_info[:track_list] = self.coder.decode track_list
  end
end