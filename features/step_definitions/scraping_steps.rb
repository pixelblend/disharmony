When /^I scrape the (.*) page$/ do |page|
  stub_scraped_page(page)
end

When /^I request the (.*) shows?$/ do |method|
  @scraper = Disharmony::Scraper.new

  @shows = @scraper.send(method.to_sym)
end

Then /^I should create a show$/ do
  assert_equal 1, @shows.size
end

Then /^I should not create a show$/ do
  assert_equal 0, @shows.size
end

Then /^with multiple zip files$/ do
  assert_equal true, @shows.first.multipart?
end

