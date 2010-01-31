require 'disharmony'

get '/' 
  @shows = Disharmony::Show.all_complete
  erb :rss
end
