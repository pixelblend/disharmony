Dir["../vendor/*/lib"].each { |path| $:.unshift path } 

ENV['RACK_ENV'] = 'production'

require 'rubygems'
require 'lib/disharmony'

Disharmony.new.download_latest
