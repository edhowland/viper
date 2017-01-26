require ls_functions.rb
install_cmd LsFunctions /v/bin
require shuffle.rb
install_cmd Shuffle /v/bin
function assert() {
  :_ || raise "expected :{_} to be true"
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
ls_functions | grep test
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
function run_1(te) {
  capture { run_befores; :te >> /v/tests/log; run_afters;  echo pass } { echo :te ':' :last_exception >> /v/tests/fails; echo fail }
}
on exit { stats; test -f /v/tests/fails && cat < /v/tests/fails }
