# mod.vsh  Establishes a module with a name and a block of functions
# After this operation,  embedded functions within the block have been
# renamed to mod_name.fn_name

# The first parameter is the name of the module
# The second param must be a block with only function  declarations
# Any other  code within the block will be  ignored
cmdlet mod '{ name, bk = *args; vm=globals[:__vm];   nbk=Block.new(bk.statement_list.filter {|s| s.class == FunctionDeclaration }.map {|f| f.set_name("#{name}.#{f.name}") }); nbk.call(env: vm.ios,  frames: vm.fs) }'
