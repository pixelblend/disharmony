When /^I scrape the (.*) page$/ do |page|
  stub_scraped_page(page)
end

When /^I find the first post$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I request the (.*) shows?$/ do |method|
  @scraper = Disharmony::Scraper.new

  @shows = @scraper.send(method.to_sym)
end

