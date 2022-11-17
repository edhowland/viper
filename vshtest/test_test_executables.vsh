source asserts.vsh
function test_test_b_w_block_true() {
  assert_exec { test -b { nop } } 'test -b with block was false'
}
function test_test_l_with_lambda_true() {
  assert_exec { test -l &() { echo hi } } 'test -l with lambda was false'
}
function test_test_x_with_block_true() {
  assert_exec { test -x { nop } } 'test -x with block was false'
}
function test_test_x_with_lanbda_true() {
  assert_exec { test -x &() { echo foo | cat } } 'test -x lambda is not true'
}
function test_test_b_with_lambda_false() {
  assert_exec_false { test -b &() { nop } } 'test -b lambda is true and should be false'
}
function test_test_l_with_block_false() {
  assert_exec_false { test -l { nop } } 'test -l with block should return false but returned ftrue'
}
function test_test_x_with_path_ctrl_s_true() {
  assert_exec { test -x /v/modes/viper/ctrl_s } 'test -x ctrl_s block did not return true'
}
function test_test_x_path_to_lambda_true() {
  store &() { nop } /v/nop_lam
  assert_exec { test -x /v/nop_lam } 'test -x /v/nop_lam did not return true'
}
function test_test_b_with_path_to_lam_false() {
  store &() { echo hi } /v/echo_lam
  assert_exec_false { test -b /v/echo_lam } 'test -b with /v/echo_lam lambda did not return false'
}
function test_test_b_path_o_lambda_false() {
  store &() { echo lam } /v/elam
  assert_exec_false { test -b /v/elam }  'test -b /v/elam should return false but did not'
}
function test_test_l_ctrl_s_false() {
  assert_exec_false { test -l /v/modes/viper/ctrl_s } 'test -l ctrl_s should be false but returned true'
}
function test_test_x_command_let_true() {
  assert_exec { test -x /v/cmdlet/misc/range } 'test -x with CommandLet was not true'
}