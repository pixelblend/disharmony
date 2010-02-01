mocks_path = File.join(File.dirname(__FILE__), '..', '..', 'mocks')

Net::HTTP.any_instance.stubs(:get).with('/2009/', nil).returns(['', File.read(File.join(mocks_path, '2009.html'))])
Net::HTTP.any_instance.stubs(:get).with('http://rollins-archive.com/2009/2009/09/saturday-sep-26-2009.html', nil).returns(['', File.read(File.join(mocks_path, 'show.html'))])
Net::HTTP.any_instance.stubs(:get).with('http://www.rollins-archive.com/2009/September/sep26.zip', nil).returns(['', File.read(File.join(mocks_path, 'test.zip'))])

# encoding: utf-8
Given /^I have not downloaded the recent show$/ do
  @disharmony = Disharmony.new
  assert_equal true, Disharmony::Show.all.empty?
end

When /^I request the current show$/ do
  @scraper = Disharmony::Scraper.new(2009)
  @shows   = @scraper.latest
end

Then /^I should see the latest show$/ do
  assert_equal 1, @shows.size
end

Then /^it should be downloaded$/ do
  Disharmony::Leecher.leech(@shows)
  assert_equal 'downloaded', @shows.first.status
  assert File.exists?(@shows.first.path)
end
