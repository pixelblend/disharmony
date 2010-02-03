# encoding: utf-8
Given /^I have not downloaded any shows$/ do
  Disharmony::Show.auto_migrate!

  @disharmony = Disharmony.new
  assert_equal 0, Disharmony::Show.count
end

When /^I request the latest show$/ do
  @scraper = Disharmony::Scraper.new
  @shows   = @scraper.latest
end

Then /^I should see the latest show$/ do
  assert_equal 1, Disharmony::Show.count
end

Then /^it should be downloaded$/ do
  Disharmony::Leecher.leech(@shows)
  assert_equal 'downloaded', @shows.first.status
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

When /^I request the recent shows$/ do   
  @scraper = Disharmony::Scraper.new

  @shows = @scraper.recent
end

When /^I scrape the (.*) page$/ do |page|
  stub_scraped_page(page)
end

Then /^I should only download the remaining (\d+) shows$/ do |count|
  assert_equal count.to_i, @shows.size
end

