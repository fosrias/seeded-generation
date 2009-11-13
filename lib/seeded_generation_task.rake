# This file was installed by the plugin SeededGeneration
# Overrides existing rake db:seed
require 'active_record'
namespace :db do
  desc "Load seeds from the db/seeds directory. Load seeds for specific models only using MODELS=x,y. Force loading all seeds using FORCE=true"
  override_task :seed => :environment do
    if ENV['MODELS']
      models = ENV['MODELS'].split(',')
      models.each do |model|
        modules = model.include?('/') ? model.split('/') : model.split('::')
        name    = modules.pop
        path    = modules.map { |m| m.underscore }
        seed_file = File.join(Rails.root, 'db/seeds', (path + [name.underscore]).join('/') + '_seeds.rb') 
        if File.exist?(seed_file)
          load(seed_file) 
        else
          STDERR.puts("ERROR: Could not locate #{seed_file} corresponding to the model #{model}.") 
        end
      end
    elsif !ENV['FORCE']
      
      # Check if rake all is desired in case 'MODELS' was mispelled.
      begin
      $stdout.print "No MODELS specified. Rake all seeds? (enter \"h\" for help) [Yqh] "
        case $stdin.gets.chomp
          when /\Aq\z/i
            $stdout.puts "aborting rake db:seed"
            raise SystemExit
          when /\Ay\z/i then 
          else
            $stdout.puts <<-HELP
			
To specify MODELS, use rake db:seed MODELS=x,y.

Y - yes, rake all seeds
q - quit, abort
h - help, show this help

To skip this message, use rake db:seed FORCE=true.
HELP
            raise 'retry'
        end
      rescue
        retry
      end
    end
    seed_file = File.join(Rails.root, 'db/seeds.rb')
    load(seed_file) if File.exist?(seed_file)
  end
end

# Overrides db:test:prepare
namespace :db do
  namespace :test do
    desc 'Loads seeds'
    override_task :prepare => :environment do
      
      #Call original aliased task
      Rake::Task[ "db:test:prepare:original" ].execute
      
      # Populate seeds
      ENV['RAILS_ENV']='test'
      ENV['FORCE']='true'
      Rake::Task[ "db:seed" ].execute
    end
  end
end