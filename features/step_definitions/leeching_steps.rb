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
  @show = @leecher.download
  assert_equal 'downloaded', @show.status
end

Then /^I should have a combined mp3 broadcast$/ do
  assert_not_nil @show.mp3
end

Then /^I should have only the correct mp3 file left$/ do
  expected_files = %w{correct_show_file.mp3 09_may_2010.mp3 #this_should_work.mp3}
  expected_files.each do |expected_file|
    assert_equal true, @leecher.send(:file_is_show?, expected_file), "#{expected_file} not valid, but should be"
  end

  incorrect_files = %w{.not_the_show_file.mp3 not_a_show_either}
  incorrect_files.each do |incorrect_file|
    assert_equal false, @leecher.send(:file_is_show?, incorrect_file), "#{incorrect_file} valid, but shouldn't be"
  end

  @show = @leecher.download
  assert_equal 'downloaded', @show.status
end
