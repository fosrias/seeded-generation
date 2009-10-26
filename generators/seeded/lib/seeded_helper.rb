# SeededGenerator Commands
require 'rails_generator/base'

# Name methods
Rails::Generator::NamedBase.class_eval do
  
  #The path to the original generator.
  def original_generator_path
    # Only calculate the original path once
    unless @original_path
      #Find the source of the original generator
      begin
        @original_path = Rails::Generator::Base.instance(file_name, ['no_options'], {}).spec.path
      rescue
         raise_missing_generator(file_name)
      end
    end
    @original_path
  end
  
  def template_path
    File.join('lib/generators', "seeded_#{file_name}", 'templates')
  end
  
  def generator_path
    File.join('lib/generators', "seeded_#{file_name}")
  end
  
  def original_template_path
    File.join(original_generator_path, 'templates')
  end
  
  private
  def raise_missing_generator(class_name)
    message = <<-end_message
      The generator '#{file_name}' does not exist in your application and is not used by Ruby on Rails.
      Please choose an alternative and run this generator again.
    end_message
              
    raise UsageError, message
  end
end

