ENV['RACK_ENV'] = 'test'

require 'cucumber/formatter/unicode'
require 'lib/disharmony'
require 'test/unit'
require 'ruby-debug'
require 'mocha'
require 'mocks'
include Test::Unit::Assertions

Disharmony::Show.auto_migrate!
