rem test_eval.vsh tests to see how eval performs
function test_eval_top_level() {
  foo=foo
  eval 'foo=bar'
  assert_eq :foo bar
}
function test_eval_within_function() {
  bar=bar
  eval 'bar=foo'
  assert_eq :bar foo
}
function test_eval_within_lambda_does_not_work() {
  baz=baz
  exec &() { eval 'baz=spam' }
  assert_neq :baz spam
}
function test_eval_within_lambda_then_global_works() {
  exec &() { eval 'quz=22; global quz' }
  assert_eq :quz 22
}
__nine=9
function eval_test(value) {
  exec &() { eval "__nine=10; global __nine" }
}
function test_eval_within_lambda_within_function_w_global_works() {
  eval_test 10
  assert_eq :__nine 10
}