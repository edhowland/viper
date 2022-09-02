source vunit.vsh
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


