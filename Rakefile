begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ms_tools"
    gem.summary = %Q{A collection of functions and tools I use in my projects.}
    gem.description = %Q{A collection of functions and tools I use in my projects. Includes helpers for javascript, stylesheets and flash messages.}
    gem.email = "will@morelandsolutions.com"
    gem.homepage = "http://github.com/wmerrell/ms_tools"
    gem.authors = ["Will Merrell"]
    gem.files = Dir["{lib}/**/*", "{app}/**/*", "{config}/**/*"]
    gem.add_dependency 'nokogiri'
    gem.add_dependency 'sanitize'
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
