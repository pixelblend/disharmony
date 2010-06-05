Disharmony - A Rollins Archive Podcasting server
================================================

Henry Rollins' Harmony in My Head is one of the best music shows on the radio. Rollins-Archive.com do a great job putting each show online but they don't do it in an Podcasting-friendly way.

This little sinatra app scrapes, downloads, tags & posts in an RSS feed each time a new show is put online.

Installation
------------

Install the Bundler gem, clone the repository and run 'Bundle install' from within the directory. You'll need [ID3-Lib installed](http://id3lib-ruby.rubyforge.org/doc/files/INSTALL.html) for this. 

web.rb is the Sinatra app, scripts/* will download shows for certain scenarios. The actual downloading of the zip files is done by wget. This app runs on my tiny XBOX server (64MB RAM) so I need to keep tight with memory usage.

All tests are written in Cucumber, I recommend using the rake test command as it will use the bundled cucumber instead ofwhatever you have installed.
