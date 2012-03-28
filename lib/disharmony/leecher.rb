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
    file_name      = self.show.air_date.strftime('himh_%Y-%m-%d')

    self.file_path = File.join(File.dirname(__FILE__), '..', '..')
    self.zip_path = File.join(self.file_path, 'tmp', file_name+'.zip')
    self.mp3_path = File.join(self.file_path, 'public',  'shows', file_name+'.mp3')

    # write zip to temp directory
    case true
    when File.exists?(self.mp3_path)
      # already downloaded, go to tagging
    when self.show.multipart? 
      # download each part of the archive
      show.mp3.split('|').each_with_index do |part, count|
        tmp_file = File.join(self.file_path, 'tmp', "#{file_name}_#{count}.mp3")
        get_and_extract(part, tmp_file)
      end
      
      #join files together
      mp3_parts = File.join(self.file_path, 'tmp', "#{file_name}*.mp3")
      
      #due to memory concerns, we're backtickin' on the shell again
      #should take a look at http://matthewkwilliams.com/index.php/2008/09/10/cat-on-steroids/
      %x{cat #{mp3_parts} > #{mp3_path}}
      
      Dir[mp3_parts].each do |part|
        File.unlink(part)
      end
    else
      get_and_extract(show.mp3)
    end
    
    show.mp3 = file_name+'.mp3'
    show.downloaded!
    show
  end
  
  private
  
  def get_and_extract(source, destination=self.mp3_path)
    Disharmony::Logger.info "Downloading #{source} to #{zip_path}"
    wget source, zip_path
    extract_zip!(destination)
  end
  
  def wget(url, output)
    %x{wget #{url} --output-document=#{output}}
  rescue SystemExit, Interrupt
    #remove temp file
    Disharmony::Logger.info "Halt recieved, deleting temporary files..."
    File.unlink(output)
    raise
  end

  def extract_zip!(destination)
    Disharmony::Logger.info 'Extracting zip'
    begin
      Zip::ZipFile.open(zip_path) do |zip_file|
        zip_file.each do |entry|
          if file_is_show?(entry.name)
            Disharmony::Logger.info "Extracting #{entry.name} from zip"
            zip_file.extract(entry, destination)
          end
        end
      end
    rescue Zip::ZipDestinationFileExistsError => e
      Disharmony::Logger.info "#{e}, skipping"
    ensure
      File.unlink(zip_path)
    end
  end

  def file_is_show?(file_name)
    # any non-hidden file ending in .mp3 should be what we're after
    !(file_name =~ /^[^\._]+(.*).mp3$/).nil?
  end
end
