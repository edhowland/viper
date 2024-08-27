function test_test_is_true() {
  echo; test :exit_status; assert_true :exit_status
}
function test_test_w_f() {
  touch /v/foo
  test -f /v/foo; assert_true :exit_status
}
function test_test_w_f_is_false() {
  test -f /v/xyzzy; assert_false :exit_status
}
function test_test_w_x() {
   mkdir /v/tmp; store { echo bar } /v/tmp/bar
  test -x /v/tmp/bar; assert_true :exit_status
}
function test_test_w_x_is_true_for_cat() {
  test -x /v/bin/cat; assert_true :exit_status
}
function test_b_works_on_vfs_stored_blocks() {
  store { nop } /v/blk
  test -b /v/blk; assert_true :exit_status

}
function test_l_works_with_vfs_stored_lambdas() {
  store &() { nop } /v/lmbd
  test -l /v/lmbd; assert_true :exit_status
  
}
function test_l_with_actual_lambda_is_true() {
  test -l &() { nop }; assert_true :exit_status
}
function test_b__with_actual_block_is_true() {
  test -b { nop }; assert_true :exit_status
}
function test_d_physical_dot_true() {
  test -d . || raise expected test -d . to be true was false
}
function test_d_dot_dot_true() {
  test -d .. || raise expected test -d .. to be true was false
}
function test_test_d_dot_virtual_true() {
  (cd /v;  test -d . || raise Expected test . in virtual /v to be true but was false)
}
function test_test_d_dot_dot_in_virtual_true() {
  (cd /v; mkdir t9/bar; cd t9/bar;  test -d .. || raise Expected test -d .. in virtual to be true but was false)
}
function test_e_no_arg_is_error_and_returns_false() {
  suppress { test -e }; assert_false :exit_status
}
function test_e_with_no_valid_pathname_returns_false() {
  suppress { test -e /v/nothing/here }; assert_false :exit_status
}
function test_e_with_non_empty_is_false() {
  test -e /v; assert_false :exit_status
}
function test_e_with_empty_dir_is_true() {
  mkdir /v/test_e_empty
  test -e /v/test_e_empty; assert_true :exit_status
}

