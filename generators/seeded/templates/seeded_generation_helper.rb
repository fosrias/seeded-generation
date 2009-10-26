#Creates commands accessed by the manifest method in seeded generators.
Rails::Generator::Commands::Create.class_eval do
  def require_seeds(seed_path)
    logger.seeds "#{seed_path}_seeds"
    unless options[:pretend]
        seed_file = File.join(Rails.root, 'db', 'seeds.rb')
        #Add to the end of the file
        File.open(seed_file, 'a+') { |f| f.write("\nrequire '#{seed_path}_seeds'") }
    end
  end
end
      
Rails::Generator::Commands::Destroy.class_eval do
  include FileUtils
  def require_seeds(*seed_path)
    look_for = "\nrequire '#{seed_path}_seeds'"
    logger.seeds "#{seed_path}_seeds"
    gsub_file 'db/seeds.rb', /(#{look_for})/mi, ''
  end
end
      
Rails::Generator::Commands::List.class_eval do
  def require_seeds(*seed_path)
    logger.seeds "#{seed_path}_seeds"
  end
end

# New name
Rails::Generator::NamedBase.class_eval do
  def seeds_path
    class_path.empty? ? file_name : File.join(class_path, file_name)
  end
end