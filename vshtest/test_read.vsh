mod test_read {
function test_read_no_args_reply() {
  echo hello | read
  assert_eq 'hello' :reply
}
function test_read_w_matching_single_arg() {
  echo foo | read bar
  assert_eq 'foo' :bar
}
function test_read_w_2_matching_args() {
  echo hello world | read foo bar
  assert_eq 'hello' :foo
  assert_eq 'world' :bar
}
function test_read_w_no_args_but_ifs_colon() {
  echo "12:34:56" | ifs=':' read
  assert_eq '12 34 56' :reply
}
function test_read_no_args_but_ofs_colon() {
  echo 'jj kk ll mm' | ofs=':' read
  assert_eq 'jj:kk:ll:mm' :reply
}
function test_read_w_more_stdin_than_args() {
  echo foo bar baz | read foo bar
  assert_eq 'foo' :foo
  assert_eq 'bar baz' ":{bar}"
}
function test_more_stdin_than_args_w_ofs_colon() {
  echo 11 22 33 | ofs=':' read eleven twothree
  assert_eq 11 :eleven
  assert_eq '22:33' :twothree
}}
