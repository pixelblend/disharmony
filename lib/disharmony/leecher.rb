require 'zip/zip'
require 'zip/zipfilesystem'
require 'net/http'
require 'uri'

class Disharmony::Leecher
# downloads, extracts and renames show file

  def download(show)
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
    
    show.downloaded!
    show
  end
end
