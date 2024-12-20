mod test_function {
function test_makes_function() {
  function _foo() { nop }
  type _foo; assert_true :exit_status
}
function test_pass_one_arg() {
  function _bar(a) { echo :a }
    assert_eq foo :(_bar foo)
}
function test_passes_two_named_args() {
  function _baz(a, b) { echo ":{a},:{b}" }
  assert_eq "1,2" :(_baz 1 2)
}
function test_collect_one() {
  function _spam() { echo :_ }
  assert_eq "1" :(_spam 1)
}
function test_collect_2() {
  function _quo() { a=:_; global a }
  _quo 1 2
  assert_eq "1 2" ":{a}"
}
function test_can_shift_1() {
  function _xxx() { shift a; global a }
  _xxx 1
  assert_eq "1" :a
  }
function test_can_shift_2() {
  function _yyy() {  shift a; shift b; global a; global b }
  _yyy 1 2
  assert_eq "1" :a
  assert_eq "2" :b
  }
function test_one_pos_one_collected() {
  function _zzz(a) { global a; shift b; global b }
  _zzz y z
  assert_eq "y" :a
  assert_eq "z" :b
}
function test_argc_1_works() {
  function _www() { a=:_argc; global a }
  _www g h i
  assert_eq 3 :a
}
function _test_shift_fewer_args() {
  assert_eq 1 2
}
function test_lambda_pass_one_arg() {
   _bar=&(a) { echo :a }
    assert_eq foo :(exec :_bar foo)
}
function test_lambda_passes_two_named_args() {
   _baz=&(a, b) { echo ":{a},:{b}" }
  assert_eq "1,2" :(exec :_baz 1 2)
}
function test_lambda_collect_one() {
  _spam=&() { echo :_ }
  assert_eq "1" :(exec :_spam 1)
}
function test_lambda_collect_2() {
  _quo=&() { a=:_; global a }
  exec :_quo 1 2
  assert_eq "1 2" ":{a}"
}
function test_lambda_can_shift_1() {
  _xxx=&() { shift a; global a }
  exec :_xxx 1
  assert_eq "1" :a
  }
function test_lambda_can_shift_2() {
  _yyy=&() {  shift a; shift b; global a; global b }
  exec :_yyy 1 2
  assert_eq "1" :a
  assert_eq "2" :b
  }
function test_lambda_one_pos_one_collected() {
  _zzz=&(a) { global a; shift b; global b }
  exec :_zzz y z
  assert_eq "y" :a
  assert_eq "z" :b
}
function test_lambda_argc_1_works() {
  _www=&() { a=:_argc; global a }
  exec :_www g h i
  assert_eq 3 :a
}
function test_stored_lambda_shifts_one_arg() {
  store &() { shift aa; echo :aa } /v/mylambda
  exec /v/mylambda 22 | read result
  assert_eq :result 22
}
function test_stored_lambda_shifts_2_arguments() {
  store &() { shift aa bb; echo ":{aa}:{bb}" } /v/l2
  exec /v/l2 11 33 | read result
  assert_eq :result 1133
}
}