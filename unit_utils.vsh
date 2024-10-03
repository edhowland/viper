# unit_utils.vsh  various  utilities for running  unit tests in  Vish

# returns the filename  part of a filename without its extension
cmdlet filepart '{ out.puts(File.basename(args[0], ".*")) }'


source map_fn_name.vsh


source add_test_file.vsh


# run a single  test function given its name
# also run any setup and teardown defined in the same module
fn run_test(tname) {
   modname=:(first :(split :tname '.')); setup_fn=":{modname}.setup"; teardown_fn=":{modname}.teardown"
   cond { suppress { declare -f:setup_fn } } { :setup_fn }
   :tname
   cond { suppress { declare -f :teardown_fn } } { :teardown_fn }
}
    
    # adds a test file by  sourcing it and  executing the  new  renamed block
# of  test functions
fn add_test_file(fname) {
   source :fname
   var=:(filepart :fname)
   eval "exec ::{var}"
}



# loop  through all files  beginning with test and ending with .vsh and add them
fn add_all_test_files() {
   for f in test_*.vsh { add_test_file :f }
}

# list any  functions that begin with 'test_'. These will be shuffled
cmdlet test_fns '{ globals[:__vm].fs.functions.keys.filter {|f| f.match("^test_.+\.test_.+") }.each {|f| out.puts f } }'

# shuffle all args and  then output them
cmdlet shuffle  '{ out.puts(args.shuffle.join(" ")) }'
