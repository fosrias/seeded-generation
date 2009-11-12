# This file should contain all the record creation needed to seed the database model with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples (with ActiveRecord validation):
#   
#   Using controllers:
#   unless <%=class_name%>.find(:first)
#     cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#     <%=class_name%>.create(:name => 'Daley', :city => cities.first)
#   end
#
#   Using models:
#   unless <%=class_name%>.find(:first)
#     [ {:name => 'Bob',    :city => 'Seattle '},
#       {:name => 'George', :city => 'Zurich'} ].each do |seed|  
#       <%=class_name%>.create(seed)  
#     end  
#   end
#
#   unless <%=class_name%>.find(:first)
#     ["Bob, Shipping",
#      "Sally, Sales"].each do |seed|
#       val = seed.split(",")
#       <%=class_name%>.create(:name => val[0], :dept => val[1])
#     end
#   end
#
#   Using comma delimited file with ActiveRecord validation:
#
#   unless <%=class_name%>.find(:first)
#     File.read(my_text_file).split("\n").each do |seed|
#       val = seed.split(",")
#       <%=class_name%>.create(:name => val[0], :dept => val[1])
#     end
#   end
#
# To seed this model individually, run rake db:seed MODELS=<%=class_name%>
#
require '<%=file_path%>'