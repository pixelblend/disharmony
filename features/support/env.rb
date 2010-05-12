ENV['RACK_ENV'] = 'test'
ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

require 'bundler'
Bundler.setup

require 'cucumber/formatter/unicode'
require 'lib/disharmony'
require 'test/unit'
require 'ruby-debug'
require 'mocha'
include Test::Unit::Assertions

#migrate, clear old data
Disharmony::Show.auto_migrate!

#create temp directories
FileUtils.mkdir_p File.join(ROOT, 'tmp', 'test', 'public', 'shows')

at_exit do
  #remove tmp directories
end
