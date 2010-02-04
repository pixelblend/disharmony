Then /^it should be downloaded$/ do
  stub_archive('simple-archive.zip')
  Disharmony::Leecher.leech(@shows)
  assert_equal 'downloaded', @shows.first.status
end

Given /^I download a show with a (.*) zip archive$/ do |zip_name|
  stub_archive("#{zip_name}-archive.zip")
  @show = stub_show()
  Disharmony::Show.auto_migrate!
  @leecher = Disharmony::Leecher.new(@show)
end

When /^I extract the zip archive$/ do
  pending # express the regexp above with the code you wish you had
end

