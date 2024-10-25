rem test_store.vsh vunit tests for the store and retrv commands
function test_store_lambda() {
   mkdir /v/tmp/test_store
   store &() { return false } /v/tmp/test_store/ret_false
   exec /v/tmp/test_store/ret_false; assert_false :exit_status
}
function test_retrv_assigns_to_var() {
   mkdir /v/tmp/test_store
   store &() { echo 11 } /v/tmp/test_store/echo_11
   retrv /v/tmp/test_store/echo_11 ec11
   assert_eq :(exec :ec11) "11"
}
function test_store_with_bad_target() {
   mkdir /v/tmp/test_store
   assert_raises { store &() { nop } /v/tmp/nada/foo }
}
function test_retrv_raises_exception_with_no_valid_path() {
   assert_raises { retrv /v/tmp/nothing/at/all foo_nothing }
}
function test_retrv_with_not_than_2_args_raises() {
   assert_raises { retrv }
}