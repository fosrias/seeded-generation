# OverrideRakeTask
require 'rake'

Rake::TaskManager.class_eval do  
  def alias_task(old_name, new_name)
    @tasks[new_name.to_s] = @tasks.delete(old_name.to_s)
  end 
end

def alias_task(old_name, new_name)
  Rake.application.alias_task(old_name, new_name)
end

# Overrides a task and creates an aliased task 'old_name:original'
# that can be called in the overriding task block
def override_task(args, &block)
  name, deps = Rake.application.resolve_args([args])  
  old_name = Rake.application[name].name
  alias_task old_name, old_name + ":original"
  task(args, &block)
end