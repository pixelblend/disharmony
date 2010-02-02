mocks_path = File.join(File.dirname(__FILE__), 'mocks')
test_zip   = File.join(mocks_path, 'test.zip')


Net::HTTP.any_instance.stubs(:get).with('/2009/', nil).returns(['', File.read(File.join(mocks_path, '2009.html'))])
Net::HTTP.any_instance.stubs(:get).with('http://rollins-archive.com/2009/2009/09/saturday-sep-26-2009.html', nil).returns(['', File.read(File.join(mocks_path, 'show.html'))])

Disharmony::Leecher.any_instance.stubs(:wget).with('http://www.rollins-archive.com/2009/September/sep26.zip', test_zip).returns(true)

Disharmony::Leecher.any_instance.stubs(:zip_path).returns(test_zip)

File.stubs(:unlink).with(test_zip).returns(true)
