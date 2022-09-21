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
  test -x /v/modes/viper/ctrl_a; assert_true :exit_status
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

