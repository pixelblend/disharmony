require 'yaml'
require 'erb'

config = File.join(File.dirname(__FILE__), '..', '..', 'config', 'config.yml')
Disharmony::Config = YAML::load(ERB.new(File.read(config)).result)
