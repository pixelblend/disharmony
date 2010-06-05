require 'yaml'
require 'erb'
require 'logger'

case ENV['RACK_ENV']
when 'script'
	log = STDOUT
  ENV['RACK_ENV'] = 'production' # now we're logging correctly, work on the production environment
else
	log = File.join(ROOT, 'log', ENV['RACK_ENV']+'.log')
end

config = File.join(ROOT, 'config', 'config.yml')

Disharmony::Config = YAML::load(ERB.new(File.read(config)).result)
Disharmony::Logger = Logger.new(log)
