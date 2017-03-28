function test_cd_ok() {
  cd /
  assert_true :exit_status
  cd :proj
  assert_true :exit_status
}
function test_cd_should_be_bad() {
  cd /yyzzyy
  assert not { test :exit_status }
}
function test_cd_virtual_ok() {
  cd /v/buf
    assert_true :exit_status
}
function test_cd_virtual_should_be_bad() {
  cd /v/buf
  cd /v/sdfjxdfdlirj
  assert not { test :exit_status }
  assert eq :pwd /v/buf
}
function test_echo_ok_path() {
  aa=aa
  echo > :aa
  rm aa
}
function test_echo_empty_path() {
  nop
}
