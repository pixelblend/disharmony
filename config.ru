ROOT = File.expand_path(File.dirname(__FILE__))

Dir["vendor/*/lib"].each { |path| $:.unshift path } 

require 'sinatra'
require 'web'

Sinatra::Application.default_options.merge!(
  :run => true,
  :env => ENV['RACK_ENV']
)

run Sinatra.application
