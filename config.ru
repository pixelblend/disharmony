require 'rubygems'
require 'sinatra'

require 'web'

Sinatra::Application.default_options.merge!(
  :run => true,
  :env => ENV['RACK_ENV']
)

run Sinatra.application
