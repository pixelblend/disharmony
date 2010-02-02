ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
ENV['RACK_ENV'] = 'production'

Dir[File.join(ROOT, "vendor/*/lib")].each { |path| $:.unshift path } 

require 'rubygems'
#require 'ruby-debug'

require File.join(ROOT, 'lib', 'disharmony')



Disharmony.new.download_latest
