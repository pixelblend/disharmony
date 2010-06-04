require 'rubygems'
require 'bundler'
Bundler.setup

require 'cucumber'
require 'cucumber/rake/task'

desc "Run all available tests"
task :test do
	Rake::Task['test:features'].invoke
end

namespace :test do
	Cucumber::Rake::Task.new(:features) do |t|
		t.cucumber_opts = "features --format pretty"
	  end
end

