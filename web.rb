require 'lib/disharmony'

get '/' do
  'hi there'
  # erb :rss
end

get '/foo/:bar' do
  "You asked for foo/#{params[:bar]}"
end