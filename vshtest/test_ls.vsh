rem test_ls.vsh tests for ls command
function test_ls_writes_to_stdout() {
  ls | read foo
  test -z :foo && assert false
}