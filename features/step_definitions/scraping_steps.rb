When /^I scrape the (.*) page$/ do |page|
  stub_scraped_page(page)
end

When /^I find post #(\d+)$/ do |post_number|
  pending # express the regexp above with the code you wish you had
end

When /^I request the (.*) shows?$/ do |method|
  @scraper = Disharmony::Scraper.new

  @shows = @scraper.send(method.to_sym)
end

Then /^I should create a show$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should not create a show$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^with multiple zip files$/ do
  pending # express the regexp above with the code you wish you had
end

