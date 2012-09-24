%w{disharmony config show scraper leecher tagger mirror}.each do |file|
  require File.join(File.dirname(__FILE__), 'disharmony', file)
end
DataMapper.finalize
