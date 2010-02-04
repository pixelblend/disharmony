Then /^it should be downloaded$/ do
  stub_archive('simple-archive.zip')
  Disharmony::Leecher.leech(@shows)
  assert_equal 'downloaded', @shows.first.status
end

Given /^I download a show with a (.*) zip archive$/ do |zip_name|
  stub_archive("#{zip_name}-archive.zip")
  Disharmony::Show.auto_migrate!
end

When /^I extract the zip archive$/ do
  @show = stub_show
  @leecher = Disharmony::Leecher.new(@show)
end
 
Then /^I should have the mp3 broadcast$/ do
#  Zip::ZipFile.any_instance.expects(:extract).with("2009_01_01 KCRW Show.mp3", mock_download_path(@show.mp3))

  @show = @leecher.download
  assert_equal 'downloaded', @show.status
end
