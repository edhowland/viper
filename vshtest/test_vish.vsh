function test_cd_ok() {
  cd /
  assert_true :exit_status
  cd :proj
  assert_true :exit_status
}
function test_cd_should_be_bad() {
  perr "The following error message is intentional"
  cd /yyzzyy
  assert_false :exit_status
}
function test_cd_virtual_ok() {
  cd /v/buf
    assert_true :exit_status
}
function test_cd_virtual_should_be_bad() {
  cd /v/buf
  perr "The following error message is intentional"
  cd /v/sdfjxdfdlirj
  assert_false :exit_status
  assert_eq :pwd /v/buf
}
function test_echo_ok_path() {
  cd /v
  aa=aa
  echo > :aa
  rm aa
  test -f aa
  assert_false :exit_status
}
function test_mv_changes_name() {
  cd /v
  touch jj
  mv jj kk
  test -f kk; assert_true :exit_status
  test -f jj; assert_false :exit_status
}
function test_echo_empty_path() {
  nop
}
function test_assert_raises() {
  assert_raises { raise bad }
}
function test_wc_sends_output_to_stdout() {
  result=:(echo hello | wc)
  assert_eq :result 6
}
function test_wc_option_l_sends_output_to_stdout() {
  result=:(echo hello | wc -l)
  assert_eq :result 1
}
function test_wc_w_option_w_sends_output_to_stdout() {
  result=:(echo hello world | wc -w)
  assert_eq :result 2
}
function test_grep_returns_true_w_match_occurs() {
  echo hello | grep hello | nop
  assert_true :exit_status
}
function test_grep_w_no_match_returns_false() {
  echo xxx | grep -q hello
  assert_false :exit_status
}
