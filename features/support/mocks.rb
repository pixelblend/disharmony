mocks_path = File.join(File.dirname(__FILE__), 'mocks')

Net::HTTP.any_instance.stubs(:get).with('/2009/', nil).returns(['', File.read(File.join(mocks_path, '2009.html'))])
Net::HTTP.any_instance.stubs(:get).with('http://rollins-archive.com/2009/2009/09/saturday-sep-26-2009.html', nil).returns(['', File.read(File.join(mocks_path, 'show.html'))])
Net::HTTP.any_instance.stubs(:get).with('http://www.rollins-archive.com/2009/September/sep26.zip', nil).returns(['', File.read(File.join(mocks_path, 'test.zip'))])
