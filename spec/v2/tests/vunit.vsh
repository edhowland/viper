require ls_functions.rb
install_cmd LsFunctions /v/bin
function units() {
ls_functions | grep test
}
function run_units() {
  map &(fn) { capture { :fn; echo pass } { echo fail } } :(units)
}
function passes() {
  count &(x) { eq :x pass } :(run_units)
}
function total() {
  count &(x) { true } :(units)
}
function failures() {
  count &(x) { eq :x fail } :(run_units)
}
function stats() {
  echo Total :(total)
  echo Passed :(passes)
  echo Failures :(failures)
}
