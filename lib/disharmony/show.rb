require 'dm-core'
DataMapper.setup(:default, Disharmony::Config['db'])

class Disharmony::Show
  include DataMapper::Resource
  
  def self.all_complete
    self.all(:status => :complete, :order => [ :air_date.desc ])
  end
  
  def air_date
    self[:air_date].rfc2822.to_s
  end
  
  def downloaded!
    self.status = :downloaded
    self.save
  end
  
  def tagged!
    complete!
  end
  
  def complete!
    self.status = :complete
    self.save
  end
  
  def path
    File.join Disharmony::Config['mp3']['path'], self.mp3
  end
  
  def url
    Disharmony::Config['server_host'] + Disharmony::Config['mp3']['url'] + self.mp3
  end
  
  storage_names[:default] = 'shows'
  property :id, Serial
  property :title, String
  property :mp3, String
  property :track_list, Text
  property :air_date, Time
  property :status, String
end

Disharmony::Show.auto_migrate!
