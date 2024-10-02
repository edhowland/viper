# map_fn_name.vsh command let  to  return new block with  renamed functions 
# functions are renamed with the  first param a period then the  original name: foo.bar()
# The second param must be a block with only function  declarations
cmdlet map_fn_name '{ name, bk = *args; globals[name.to_sym] = Block.new(bk.statement_list.filter {|s| s.class == FunctionDeclaration }.map {|f| f.set_name("#{name}.#{f.name}") }) }'
