require 'yaml'
require 'erb'
require 'logger'

config = File.join(ROOT, 'config', 'config.yml')
log    = File.join(ROOT, 'log', ENV['RACK_ENV']+'.log')
Disharmony::Config = YAML::load(ERB.new(File.read(config)).result)
Disharmony::Logger = Logger.new(log)
