require 'yaml'

%w{disharmony config show scraper leecher tagger}.each do |file|
  require File.join(File.dirname(__FILE__), 'disharmony', file)
end
