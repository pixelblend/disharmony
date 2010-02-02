require 'lib/disharmony'

get '/' do
  @shows = Disharmony::Show.all_complete
  erb :rss
end
