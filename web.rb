ROOT = File.expand_path(File.dirname(__FILE__))

require File.join ROOT, 'lib', 'disharmony'

get '/' do
  @shows = Disharmony::Show.all_complete
  erb :rss
end
