function setup_buf() {
  open xxx
  __obuf=:_buf; global __obuf
  new_clip
}
function teardown_buf() {
  rm :__obuf
  unset _buf
  unset _clip
}
function x_test_cut_off_by_1() {
  echo 0123456789 > :_buf
  fwd :_buf
  m _
  fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf
  mark_cut :_buf :_mark 
  assert_eq 056789 :(cat < :_buf)
}
function x_test_copy() {
  echo hello world > :_buf
  m m
  fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf
  mark_copy :_buf m
  assert_eq hello :(cat < :_clip)
}
function test_paste() {
  echo -n "hello" | ins :_buf
  new_clip
  echo -n ' world' | ins :_clip
  fin :_buf
  cat :_clip | ins :_buf
  yy=:(cat :_buf)
  assert_eq 'hello world' ":{yy}"
}
function test_del_word_fwd() {
echo -n 'hello world' | ins :_buf
beg :_buf
del_word_fwd :_buf
   beg :_buf; fwd :_buf
assert_eq 'w' :(at :_buf)
}
function x_test_mark_cut_releases_mark() {
  echo hello_world_sailor | ins :_buf
  beg :_buf
  fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf
  m m
  fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf
  apply ctrl_x
  fin :_buf
  apply key_backspace
  assert_eq :(cat < :_buf) 'hello_sailor'
}
function test_w_no_mark_raise_w_cut() {
  echo hello world | ins :_buf
  beg :_buf
  fwd :_buf
  m m
  fwd :_buf
  fwd :_buf
  fwd :_buf
  mark_cut :_buf :_mark
  fin :_buf
  back :_buf; back :_buf
}
function x_test_simple_apply() {
  echo hello | ins :_buf
  beg :_buf
  _mode=viper applyf move_right
}
function test_apply_key_d() {
  echo hello | ins :_buf
  apply key_d
}
function test_new_fn() {
  function dim(key) { exec "/v/modes/:{_mode}/:{key}" jj }
  scratch
  _mode=viper dim fn_2
}
function test_should_ask2_save() {
  ask2_save :_buf
    assert_true :exit_status
}
