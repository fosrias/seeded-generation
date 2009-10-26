# Extends functionality in the <%=file_name%> generator to create model
# seeds files and directories.

class Seeded<%=class_name%>Generator < <%=class_name%>Generator
  
  default_options[:skip_seeds] = false
  default_options[:seeds_only] = false
   
  alias base_add_options! add_options!
  alias base_manifest manifest
   
  def manifest
    if !options[:seeds_only]
      m = base_manifest
    else
      m = record {}
    end
    unless options[:skip_seeds]
      # Generate the seeds stub directory mirroring the model directory structure.
      m.directory File.join('db/seeds', class_path)
      
      # Generate the seeds stub
      m.template 'seeds.rb', File.join('db/seeds/', class_path, "#{file_name}_seeds.rb")
    end
  
    # Register the seeds stub in seeds.rb at the end of the file
    m.gsub_file('db/seeds.rb', File.read(File.join(RAILS_ROOT, 'db/seeds.rb'))) do |s|
      s + "\nrequire '#{file_path}_seeds'"
    end if options[:command] == :create && !options[:skip_seeds]
    m.gsub_file('db/seeds.rb', /\nrequire '#{file_path}_seeds'/mi, '') if options[:command] == :destroy
    m
  end
  
  protected
  def banner
    "Usage: #{$0} seeded_<%=file_name%> ModelName [field:type, field:type]"
  end
  
  def add_options!(opt)
    base_add_options!(opt)
    opt.on("--skip-seeds",
           "Don't generate a seeds file for this model.") { |v| options[:skip_seeds] = v }
    opt.on("--seeds-only",
           "Only generate a seeds file for this model.") { |v| options[:seeds_only] = v }
  end
end