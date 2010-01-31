require 'yaml'

%w{disharmony show scraper leecher tagger}.each do |file|
  require File.join(File.dirname(__FILE__), 'disharmony', file)
end

config = File.join(File.dirname(__FILE__), '..', 'config', 'config.yml')
Disharmony::Options = YAML::load(File.new(config, 'r'))
