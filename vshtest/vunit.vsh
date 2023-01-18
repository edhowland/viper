cd ":{vhome}/vshtest"
source load_commands.vsh
alias assert_true=assert
function assert(obj) {
  is_true :obj || raise "expected :{obj} to be true"
}
function assert_empty(obj) { test -z :obj || raise Expected :obj to be empty }
function assert_not_empty() {
  not { test -z :_ }  || raise expected :_ to not be empty but was
}
function assert_raises() {
  capture :_ && raise expected exception got none
}
function assert_false(obj) {
  is_false :obj || raise Expected true to be false
}
function assert_eq(left, right) {
  eq ":{left}" ":{right}" || raise "Expected |:{left}| to equal |:{right}|"
}
function assert_neq(left, right) {
   not { eq ":{left}" ":{right}" } ||  raise "Expected |:{left}| to not equal |:{right}|"
}
mkdir /v/tests
function befores() {
  ls_functions | grep setup
}
function run_befores() {
  each &(f) { :f } :(befores)
}
function afters() {
  ls_functions | grep teardown
}
function run_afters() {
  each &(f) { :f } :(afters)
}
function units() {
ls_functions | grep '/^test/'
}
function run_units() {
  map &(fn) { capture { run_befores; :fn >> /v/tests/log; run_afters; echo pass } { echo :fn ':' :last_exception >> /v/tests/fails; echo :fn } } :(shuffle :(units))
}
function passes() {
  count &(x) { eq :x pass } :_
}
function total() {
  count &(x) { true } :_
}
function failures() {
  count &(x) { not { eq :x pass } } :_
}
function fails() {
  filter &(f) { not { eq :f pass } } :_
}
function all_fails() {
  cat < /v/tests/fails
}
function stats() {
  set=:(run_units)
  eq 0 :(failures :set) || (echo Failures; each &(x) { echo :x } :(fails :set))
  echo
  echo Total :(total :set)
  echo Passed :(passes :set)
  echo Failures :(failures :set)
}
alias report_fails='cat < /v/tests/fails'
alias x='echo :exit_status'
function run_one(te) {
  test -f /v/tests/log && rm /v/tests/log
  test -f /v/tests/fails && rm /v/tests/fails
  capture { run_befores; :te >> /v/tests/log; run_afters;  echo pass } { echo :te ':' :last_exception >> /v/tests/fails; cat < /v/tests/fails }
}
at_exit { 
  stats
  test -f /v/tests/fails && cat < /v/tests/fails && set_exit_code 1 
}
cmdlet slice_of '{ f,l = args[0..1].map(&:to_i); src = (args[2] == "-" ? inp.read.chomp : args[2]); out.puts src[(f)..(l)] }'


