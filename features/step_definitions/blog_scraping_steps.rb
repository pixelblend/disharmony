mocks_path = File.join(File.dirname(__FILE__), '..', '..', 'mocks')

Net::HTTP.any_instance.stubs(:get).with('/2009/', nil).returns(['', File.read(File.join(mocks_path, '2009.html'))])
Net::HTTP.any_instance.stubs(:get).with('/2009/2009/09/saturday-sep-26-2009.html', nil).returns(['', File.read(File.join(mocks_path, 'show.html'))])
Net::HTTP.any_instance.stubs(:get).with('/test.zip', nil).returns(['', File.read(File.join(mocks_path, 'test.zip'))])

# encoding: utf-8
Given /^I have not downloaded any recent shows$/ do
  @disharmony = Disharmony.new
  assert_equal false, @disharmony.shows.downloaded.empty?, @disharmony.shows.downloaded.inspect
end

When /^I request a list of shows$/ do
  @disharmony.scrape_latest_shows
end

Then /^I should see the latest 10 shows$/ do
  assert_equal 10, @disharmony.shows.latest.size
end


Given /I have a list of recent shows$/ do
  @disharmony = Disharmony.new
  @disharmony.scrape_latest_shows
  assert_equal 10, @disharmony.shows.latest.size
end

When /^I download the latest show$/ do
  @disharmony.download_show(0)
end

Then /^it should save the archive file$/ do
  pending
end

Then /^extract the mp3$/ do
  pending
end

Then /^add Podcast ID3 tags$/ do
  pending
end