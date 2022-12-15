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