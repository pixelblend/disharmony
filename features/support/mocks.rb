def mocks_path
  File.join(File.dirname(__FILE__), 'mocks')
end

test_zip   = File.join(mocks_path, 'test.zip')

Disharmony::Leecher.any_instance.stubs(:wget).returns(true)

Disharmony::Leecher.any_instance.stubs(:zip_path).returns(test_zip)

File.stubs(:unlink).with(test_zip).returns(true)

def stub_scraped_page(file)
  Net::HTTP.any_instance.stubs(:get).returns(['', File.read(File.join(mocks_path, "#{file}.html"))])
end
