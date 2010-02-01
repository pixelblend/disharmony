require 'zip/zip'
require 'zip/zipfilesystem'
require 'net/http'
require 'uri'

class Disharmony::Leecher
  attr_accessor :response, :show, :data, :mp3_path, :zip_path
  
  def self.leech(shows)
    shows.collect do |show|
      leech = self.new(show)
      leech.download
    end
  end
  
  def initialize(show)
    self.show = show
  end
  
  def download
    uri = URI.parse(Disharmony::Config['source_host'])
    self.response, self.data = Net::HTTP.new(uri.host, uri.port).get(show.mp3, nil)
    
    
    # write zip to temp directory
    file_name = self.show.title.downcase.gsub(' ', '_').gsub(/[^\w\d]/, '')
    file_path = File.join(File.dirname(__FILE__), '..', '..')
    
    self.zip_path = File.join(file_path, 'tmp', file_name+'.zip')
    self.mp3_path = File.join(file_path, 'public',  'shows', file_name+'.mp3')
    
    File::open(zip_path, "wb+") do |zip_file|
      zip_file.write(self.data)
    end
    
    Zip::ZipFile.open(zip_path) do |zip_file|
      case zip_file.entries.size
      when 1
        zip_file.entries.first.extract(mp3_path)
      else
        raise "Don't know how to handle #{zip_file.entries.size} files in a zip"
      end
    end
    File.unlink(zip_path)
    #File.unlink(mp3_path)
    
    show.mp3 = file_name+'.mp3'
    show.downloaded!
    show
  end
end
