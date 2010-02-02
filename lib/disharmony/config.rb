require 'yaml'
require 'erb'
require 'logger'

config = File.join(File.dirname(__FILE__), '..', '..', 'config', 'config.yml')
log    = File.join(File.dirname(__FILE__), '..', '..', 'log', ENV['RACK_ENV']+'.log')
Disharmony::Config = YAML::load(ERB.new(File.read(config)).result)
Disharmony::Logger = Logger.new(log)
