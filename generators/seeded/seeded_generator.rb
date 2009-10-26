# Generator that modifies existing generators to create individual
# model seeds stubs.
require File.join(File.dirname(__FILE__), 'lib/seeded_helper')
class SeededGenerator < Rails::Generator::NamedBase

  def manifest
    # Check for seeded generator class naming collisions.
    if class_name.include?('Seeded')
      raise "The generator #{class_name.underscore} is already seeded."
    end
      
    record do |m|    
      # Create generator and template directories.
      m.directory generator_path
      m.directory template_path

      # Create generator
      m.template 'generator.rb', File.join(generator_path, "seeded_#{file_name}_generator.rb")
      
      # Copy seeded generator templates
      m.file 'seeds.rb', File.join(template_path, 'seeds.rb')
      
      # Copy base generator templates
      Dir.foreach(original_template_path) do |f|
        m.file file_name + ':' + f, File.join(template_path, f), :collision => :skip unless File.directory?(f)
      end
      
      # Copy the usage file
      m.file file_name + ':' + '../USAGE', File.join(generator_path, 'USAGE'), :collision => :skip
    
      unless options[:command] == :destroy
        # Update it if it is a scaffold USAGE statement
        m.gsub_file File.join(generator_path,'USAGE'), "from model and migration" do 
          "from model, migration and seeds"
        end 
        
        # Update it if it is a model USAGE statement
        m.gsub_file File.join(generator_path,'USAGE'), ", and a migration in\n    db/migrate." do 
          ", a migration in\n    db/migrate, and a seed in db/seeds."
        end
        
        m.gsub_file File.join(generator_path,'USAGE'), "creates an Account model, test, fixture, and migration:" do 
          "creates an Account model, test, fixture, migration, and seeds:"
        end
        
        m.gsub_file File.join(generator_path,'USAGE'), "Migration:  db/migrate/XXX_add_accounts.rb" do 
          "Migration:  db/migrate/XXX_add_accounts.rb\n            Seeds:      db/seeds/account_seeds.rb"
        end
      end
    end
  end
  
  protected
  def banner
    "Usage: #{$0} seeded generator_name"
  end

end