require 'disharmony'

get '/' 
  @shows = Disharmony::Show.all
  erb :rss
end
