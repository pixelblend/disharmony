require 'dm-core'
require 'dm-validations'
require 'dm-aggregates'

DataMapper.setup(:default, Disharmony::Config['db'])

class Disharmony::Show
  include DataMapper::Resource
  validates_is_unique :title
  validates_present   :mp3
  
  def self.all_complete
    self.all(:status => :complete, :order => [ :air_date.desc ])
  end
  
  def self.find_scraped(title)
    self.first(:title => title, :status => :scraped)  
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
    Disharmony::Config['mp3']['url'] + self.mp3
  end
  
  storage_names[:default] = 'shows'  
  property :id, Serial
  property :title, String
  property :mp3, Text
  property :track_list, Text
  property :air_date, Time
  property :status, String
end

Disharmony::Show.auto_upgrade!

