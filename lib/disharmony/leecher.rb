require 'zip/zip'
require 'zip/zipfilesystem'

class Disharmony::Leecher
  attr_accessor :response, :show, :data, :mp3_path, :zip_path, :file_path
  
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
    # write zip to temp directory
    file_name = self.show.title.downcase.gsub(' ', '_').gsub(/[^\w\d]/, '')
    self.file_path = File.join(File.dirname(__FILE__), '..', '..')
    
    self.zip_path = File.join(self.file_path, 'tmp', file_name+'.zip')
    self.mp3_path = File.join(self.file_path, 'public',  'shows', file_name+'.mp3')

    Disharmony::Logger.info "Downloading #{show.mp3}"
    wget show.mp3, zip_path
    
    Disharmony::Logger.info 'Extracting zip'
    begin
      Zip::ZipFile.open(zip_path) do |zip_file|
        zip_file.each do |entry|
          unless (entry.name =~ /^[a-zA-Z0-9]+(.*).mp3$/).nil?
            zip_file.extract(entry, mp3_path)
          end
        end
      end
    rescue Zip::ZipDestinationFileExistsError => e
      Disharmony::Logger.info "#{e}, skipping"
    ensure
      File.unlink(zip_path)
    end
    
    show.mp3 = file_name+'.mp3'
    show.downloaded!
    show
  end
  
  private
  
  def wget(url, output)
    `wget #{url} --output-document=#{output}`
  end
end
