# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
include Rake::DSL
require 'rake'

module ::Ligi
  class Application
#    include Rake::DSL
  end
end
 
module ::RakeFileUtils
  extend Rake::FileUtilsExt
end

Ligi::Application.load_tasks
