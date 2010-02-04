# encoding: utf-8
Given /^I have not downloaded any shows$/ do
  Disharmony::Show.auto_migrate!

  @disharmony = Disharmony.new
  assert_equal 0, Disharmony::Show.count
end

Then /^I should see the latest show$/ do
  assert_equal 1, Disharmony::Show.count
end

Then /^it should be tagged correctly$/ do
  Disharmony::Tagger.tag!(@shows.first)
  assert_equal 'complete', @shows.first.status
end

Then /^available in the correct location$/ do
  assert File.exists?(@shows.first.path)
end

Then /^it should not be available to download again$/ do
  assert_equal 1, Disharmony::Show.count

  new_shows   = @scraper.latest  
  
  assert new_shows.empty?
  assert_equal 1, Disharmony::Show.count
end

Given /^I have the latest show$/ do
  assert_equal 1, Disharmony::Show.count
end

Then /^I should only download the remaining (\d+) shows$/ do |count|
  assert_equal count.to_i, @shows.size
end

