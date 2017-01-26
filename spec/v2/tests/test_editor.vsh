function test_cut_off_by_1() {
  open buf
  echo 0123456789 > :_buf
  fwd :_buf
  m _
  fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf
  mark_cut :_buf :_mark 
  assert eq 056789 :(cat < :_buf)
}
function test_copy() {
  open buf_cp
  echo hello world > :_buf
  m m
  fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf
  mark_copy :_buf m
  assert eq hello :(cat < :_clip)
}
function test_paste() {
  open buf_n
  echo hello > :_buf
  new_clip
  echo ' world' > :_clip
  fin :_buf
  cat < :_clip | ins :_buf
  yy=:(cat < :_buf)
  assert eq 'hello world' ":{yy}"
}
