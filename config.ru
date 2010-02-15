require 'bundler'
Bundler.setup

require 'sinatra'
require 'web'

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => ENV['RACK_ENV']
)

run Sinatra::Application
