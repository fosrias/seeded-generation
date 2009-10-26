# Uninstall code
require 'fileutils'
path = File.join(RAILS_ROOT, 'lib/seeded_generation')
FileUtils::copy(File.join(File.dirname(__FILE__),  'lib/Notes'), path)
puts File.read(File.join(path, 'Notes'))