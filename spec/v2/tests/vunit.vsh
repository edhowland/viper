require ls_functions.rb
install_cmd LsFunctions /v/bin
require shuffle.rb
install_cmd Shuffle /v/bin
function units() {
ls_functions | grep test
}
function run_units() {
  map &(fn) { capture { :fn; echo pass } { echo fail } } :(shuffle :(units))
}
function passes() {
  count &(x) { eq :x pass } :_
}
function total() {
  count &(x) { true } :_
}
function failures() {
  count &(x) { eq :x fail } :_
}
function stats() {
  set=:(run_units)
  echo Total :(total :set)
  echo Passed :(passes :set)
  echo Failures :(failures :set)
}
