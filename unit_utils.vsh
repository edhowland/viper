# unit_utils.vsh  various  utilities for running  unit tests in  Vish

# acts like  grep on  input lines
cmdlet vgrep '{ inp.read.lines.filter {|e| e.match(args[0]) }.each {|n| out.puts n } }'
# returns the filename  part of a filename without its extension
cmdlet filepart '{ out.puts(File.basename(args[0], ".*")) }'

# list all  currently know function names
cmdlet  fn_names '{ globals[:__vm].fs.functions.keys.each {|f| out.puts f } }'
source map_fn_name.vsh


source add_test_file.vsh



# initializes /v/tests if not already  done
alias clear_logs='test -f /v/tests && rm -rf /v/tests; mkdir /v/tests;touch /v/tests/passes; touch /v/tests/fails; touch /v/tests/log; touch /v/tests/errlog'


# run a single  test function given its name
# also run any setup and teardown defined in the same module
fn run_test(tname) {
   modname=:(first :(split :tname '.')); setup_fn=":{modname}.setup"; teardown_fn=":{modname}.teardown"
   capture {
   cond { suppress { declare -f:setup_fn } } { echo -n ":{setup_fn} " >> /v/tests/log;  :setup_fn >> /v/tests/log }
   echo -n ":{tname}: " >> /v/tests/log
   :tname >> /v/tests/log
   cond { suppress { declare -f :teardown_fn } } { echo  -n ":{teardown_fn} " >> /v/tests/log; :teardown_fn >> /v/tests/log }
      echo  ":{tname}: Ok" >> /v/tests/passes
   } { echo -n ":{tname} :{last_exception}" >> /v/tests/fails }
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
   for f in test_*.vsh { add_test_file :f; echo  loading  :f }
}

# list any  functions that begin with 'test_'. These will be shuffled
alias test_fns="fn_names | vgrep '^test_.+\.test_.+'"

# shuffle all args and  then output them
cmdlet shuffle  '{ out.puts(args.shuffle.join(" ")) }'


# runs  all tests thathave been shuffled
fn run_all_tests() {
for t in :(shuffle :(test_fns)) {
      run_test :t
   }
}

# output any logs creted during any tests that were run
fn log_of_tests() {
   test -f /v/tests/log && cat /v/tests/log
}

# report  statistics of all test runs
fn stats() {
   echo 0 passed
   test -f /v/tests/passes && cat < /v/tests/passes
   echo  0 failures
    test -f /v/tests/fails &&  cat < /v/tests/fails
   echo 0 Total
}
