# Install hook code here
require 'fileutils'
# Install utility code so functionality can work if plugin unintalled
dir = File.join(RAILS_ROOT, 'lib/seeded_generation')
begin
  Dir.mkdir(dir)
  puts "Created the directory " + dir
rescue => e
  # Do nothing if it exists
end

# Copy rake task and helper so functionality can work if plugin unintalled
e = <<EDELIM 
already exists.
Please delete the file or change the existing file name
and reinstall the plugin to avoid this conflict.\n
EDELIM

path = File.join(RAILS_ROOT,'lib/tasks')
if File.exist?(File.join(dir, 'override_rake_task.rb'))
  STDERR.puts("ERROR: File #{dir}/override_rake_task.rb " + e ) 
  STDERR.puts("ERROR: File #{path}/seeded_generation_task.rake " + e ) if File.exist?(File.join(path, 'seeded_generation_task.rake'))
  raise
  exit(1)
elsif File.exist?(File.join(path, 'seeded_generation_task.rake'))
  STDERR.puts("ERROR: File #{path}/seeded_generation_task.rake " + e ) 
  raise
  exit(1)
else 
  FileUtils.copy(File.join(File.dirname(__FILE__), 'lib/override_rake_task.rb'), dir)
  puts "\nAdded file ../lib/seeded_generation/override_rake_task.rb."
  FileUtils.copy(File.join(File.dirname(__FILE__), 'lib/seeded_generation_task.rake'), path )
  puts "Added file ../lib/tasks/seeded_generation_task.rake."
end

# Insert line: [require 'utilities/seeded_helper']
# before "require 'rake'" in Rakefile
path = File.join(RAILS_ROOT, 'Rakefile')
unless File.exists?(path)
    STDERR.puts('ERROR: Could not locate Rakefile') 
    exit(1)
end
line_to_insert = %Q{# Added by seeded-generation plugin.\nrequire 'seeded_generation/override_rake_task'\n\n} 
content = File.read(path)
unless content.include?(line_to_insert)
  content = content.gsub(/require 'rake'/) {|s| line_to_insert + s } 
  File.open(path, 'wb') { |file| file.write(content) }
  puts "\nAdded require 'seeded_generation/override_rake_task' to the Rakefile."
end

# Insert line: [config.load_paths += %W( #{RAILS_ROOT}/db/seeds)"]
# at the end of the intializer block in environment.rb.
path = File.join(RAILS_ROOT, 'config/environment.rb')
unless File.exists?(path)
    STDERR.puts('ERROR: Could not locate environment.rb') 
    exit(1)
end

# Insert 
# Update path configurations
line_to_insert = %Q{\n  # Added by seeded-generation plugin.\n} << %q{  config.load_paths += %W( #{RAILS_ROOT}/db/seeds )}
content = File.read(path)
unless content.include?(%q{#{RAILS_ROOT}/db/seeds})
  content = content.gsub(/[\n]end/m) {|s| "\n" + line_to_insert + s}
  File.open(path, 'wb') { |file| file.write(content) }
  puts "Added db/seeds to the load paths configuration in ../config/environment.rb."
end

# Insert line in seeds.db to separate seeds require references
path = File.join(RAILS_ROOT, 'db/seeds.rb')
unless File.exists?(path)
    STDERR.puts('ERROR: Could not locate db/seeds.rb.\n Please create this file and reinstall the plugin') 
    exit(1)
end
line_to_insert = <<LINE
# Added by seeded-generation plugin.
# Load seeds for specific models only using rake db:seed MODELS=x,y
#
# Otherwise, include all the following seeds for rake db:seed
LINE
content = File.read(path)
unless content.include?(line_to_insert)
  content += line_to_insert
  File.open(path, 'wb') { |file| file.write("\n\n\n" + content) }
  puts "Added seeds reference placedholder to ../db/seeds.rb."
end

# Generate seeded_model
puts "\nGenerating seeded_model generator"
`ruby script/generate seeded model`

# Generate seeded_scaffold
puts "Generating seeded_scaffold generator"
`ruby script/generate seeded scaffold`

puts "\nseeded-generation plugin installed. \nSee README for more information."