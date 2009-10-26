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

# Allows using create or update in rake db:seed
# See Michael Bleigh http://www.intridea.com/2008/2/19/activerecord-base-create_or_update-on-steroids-2?blog=company
class << ActiveRecord::Base  
  def create_or_update(options = {})  
    self.create_or_update_by(:id, options)  
  end  
  
  def create_or_update_by(field, options = {})  
    find_value = options.delete(field)  
    record = find(:first, :conditions => {field => find_value}) || self.new  
    record.send field.to_s + "=", find_value  
  record.attributes = options  
  record.save!  
  record  
end  

def method_missing_with_create_or_update(method_name, *args)  
  if match = method_name.to_s.match(/create_or_update_by_([a-z0-9_]+)/)  
      field = match[1].to_sym  
      create_or_update_by(field,*args)  
    else  
      method_missing_without_create_or_update(method_name, *args)  
    end  
  end  
   
  alias_method_chain :method_missing, :create_or_update  
end