require 'lib/disharmony'

get '/' 
  erb :rss
end

get '/foo/:bar' do
  "You asked for foo/#{params[:bar]}"
end
