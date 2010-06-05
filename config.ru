begin
  require File.join(File.dirname(__FILE__), '.bundle', 'environment')
rescue Exception => e
  raise 'Unpack gems with `bundle package` or rack will give you pain :('
end

require 'sinatra'
require 'web'

set :run, false
set :env, ENV['RACK_ENV']

run Sinatra::Application
