ENV['RACK_ENV'] = 'test'
ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
Dir[File.join ROOT, "vendor/*/lib"].each { |path| $:.unshift path } 

require 'cucumber/formatter/unicode'
require 'lib/disharmony'
require 'test/unit'
require 'ruby-debug'
require 'mocha'
include Test::Unit::Assertions
