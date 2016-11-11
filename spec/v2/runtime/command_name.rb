# command_name - module CommandName - method command_name
# outputs the lower case name of the class

 module CommandName
   def command_name
     self.class.name.downcase
   end
 end
