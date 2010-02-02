mocks_path = File.join(File.dirname(__FILE__), 'mocks')
test_zip   = File.join(mocks_path, 'test.zip')


Net::HTTP.any_instance.stubs(:get).with('/2009/', nil).returns(['', File.read(File.join(mocks_path, '2009.html'))])
Net::HTTP.any_instance.stubs(:get).returns(['', File.read(File.join(mocks_path, 'show.html'))])

Disharmony::Leecher.any_instance.stubs(:wget).returns(true)

Disharmony::Leecher.any_instance.stubs(:zip_path).returns(test_zip)

File.stubs(:unlink).with(test_zip).returns(true)
