# This file should contain all the record creation needed to seed the database model with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples (with ActiveRecord validation):
#   
#   Using controllers:
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   <%=class_name%>.create(:name => 'Daley', :city => cities.first)
#
#   Using models:
#   [ {:name => 'Bob',    :city => 'Seattle '},
#     {:name => 'George', :city => 'Zurich'} ].each do |seed|  
#     <%=class_name%>.create_or_update_by_name(seed)  
#   end  
#
#   { 'employee' => ['Robert', 'Sales'],   
#     'manager'  => ['Renee', 'Manufacturing'] }.each_pair do |key, val|  
#     <%=class_name%>.create_or_update_by_key(:key => key, :name => val[0], :dept => val[1])  
#   end 
#
#   Using comma delimited file with ActiveRecord validation:
#   File.read(my_text_file).split("\n").each do |seed|
#     val = seed.split(",")
#     <%=class_name%>.create_or_update_by_name(:name => val[0], :dept => val[1])
#   end
#
# To seed this model individually, run rake db:seed MODELS=<%=class_name%>
#
require '<%=file_path%>'