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
    # write zip to temp directory
    file_name = self.show.title.downcase.gsub(' ', '_').gsub(/[^\w\d]/, '')
    file_path = File.join(File.dirname(__FILE__), '..', '..')
    
    self.zip_path = File.join(file_path, 'tmp', file_name+'.zip')
    self.mp3_path = File.join(file_path, 'public',  'shows', file_name+'.mp3')

    Disharmony::Logger.info "Downloading #{show.mp3}"
    wget show.mp3, zip_path
    
    Disharmony::Logger.info 'Extracting zip'
    begin
      Zip::ZipFile.open(zip_path) do |zip_file|
        zip_file.each do |entry|
          unless (entry.name =~ /.mp3$/).nil?
            zip_file.extract(entry, mp3_path)
          end
        end
      end
    rescue Zip::ZipDestinationFileExistsError => e
      Disharmony::Logger.info "#{e}, skipping"
    ensure
      File.unlink(zip_path)
    end
    
    Disharmony::Logger.info 'Show downloaded'
    
    show.mp3 = file_name+'.mp3'
    show.downloaded!
    show
  end
  
  private
  
  def wget(url, output)
    `wget #{url} --output-document=#{output}`
  end
end
