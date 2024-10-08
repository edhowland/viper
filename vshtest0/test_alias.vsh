alias _i_will_fail=echo
function will_fail_when_twice_called() {
  _i_will_fail
}
function test_alias_can_be_called_twice_in_twice_called_fn() {
will_fail_when_twice_called
 will_fail_when_twice_called 
}

