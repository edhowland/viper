# path_from_start_elements.rb 
#- method path_from_start_elements start, [elements ...] 
# returns absolute or relative from start string and elements

 def path_from_start_elements start, elements=[]
   (start.empty? ? '/' : '') + elements.join('/')
 end
