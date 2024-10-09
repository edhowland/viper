# assert.vsh vish assertion library


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
# to make tests here work TODO  remove this after assert_true becomes assert
alias assert_true=assert


function assert_exec(f, message) {
  exec :f || raise "expected block or function to return true but returned :{exit_status} instead :{message}"
}
  function assert_exec_false(f,message) {
  exec :f &&  raise "expected block or function to return false but returned :{exit_status} instead :{message}"
}