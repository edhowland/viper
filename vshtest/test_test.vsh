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
