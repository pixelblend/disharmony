def mocks_path(file)
  File.join(File.dirname(__FILE__), 'mocks', file)
end

def mock_download_path(file='')
  File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'test', file)
end

def stub_archive(file)
  test_zip   = mocks_path(file)
  
  Disharmony::Leecher.any_instance.stubs(:file_path).returns(mock_download_path)
  Disharmony::Leecher.any_instance.stubs(:wget).returns(true)
  Disharmony::Leecher.any_instance.stubs(:zip_path).returns(test_zip)
  File.stubs(:unlink).with(test_zip).returns(true)
end

def stub_scraped_page(file)
  Net::HTTP.any_instance.stubs(:get).returns(stub(:body => File.read(mocks_path("#{file}.xml"))))
end

def stub_show(new_attributes={})
  attributes = {
    :title => Time.now.to_s,
    :mp3 => 'mp3_location.mp3',
    :status => 'scraped',
    :air_date => Time.now
  }
  
  show = Disharmony::Show.new
  show.attributes = attributes.merge(new_attributes)
  show.save
  
  show
end
