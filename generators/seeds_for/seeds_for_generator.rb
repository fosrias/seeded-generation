# Extends functionality in the <%=file_name%> generator to create model
# seeds files and directories.
class SeedsForGenerator < Rails::Generator::NamedBase
   
  def manifest
    if !File.exist?(File.join(RAILS_ROOT, 'app/models', "#{file_path}.rb"))
      raise "The model #{class_name} does not exist."
    end
    record do |m|
      # Generate the seeds stub directory mirroring the model directory structure.
      m.directory File.join('db/seeds', class_path)
      
      # Generate the seeds stub
      m.template 'seeds.rb', File.join('db/seeds/', class_path, "#{file_name}_seeds.rb")
      
      # Register the seeds stub in seeds.rb at the end of the file
      m.gsub_file('db/seeds.rb', File.read(File.join(RAILS_ROOT, 'db/seeds.rb'))) do |s|
        s + "require '#{file_path}_seeds'\n"
      end if options[:command] == :create
      m.gsub_file('db/seeds.rb', /\nrequire '#{file_path}_seeds'/mi, '') if options[:command] == :destroy
    end
  end
  
  # Override with your own usage banner.
  def banner
    "Usage: #{$0} seed_model ModelName"
  end
end