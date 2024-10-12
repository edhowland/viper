rem test_ls.vsh tests for ls command
function test_ls_writes_to_stdout() {
  ls | read foo
  test -z :foo && assert false
}
function test_ls_w_no_such_file_writes_to_stderr() {
  echo the folloing error message is intential
  ls no_such_file | nop | read
  assert_empty :reply
}
function test_ls_returns_true_when_files_exist() {
   mkdir /v/tmp/ls1
    (cd /v/tmp/ls1; touch f9; ls f9; assert :exit_status)
}
function test_ls_returns_false_when_one_or_more_file_is_non_existant() {
mkdir /v/tmp/ls2;touch /v/tmp/ls2/f
(cd /v/tmp/ls2;ls f b;assert_false :exit_status)
}