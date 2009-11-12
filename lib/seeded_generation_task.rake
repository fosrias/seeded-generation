# This file was installed by the plugin SeededGeneration
# Overrides existing rake db:seed
require 'active_record'
namespace :db do
  desc "Load seeds from the db/seeds directory. Load seeds for specific models only using MODELS=x,y."
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
    else
      
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
HELP
            raise 'retry'
        end
      rescue
        retry
      end
      seed_file = File.join(Rails.root, 'db/seeds.rb')
      load(seed_file) if File.exist?(seed_file)
    end
  end
end