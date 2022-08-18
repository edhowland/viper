function setup() {
  open xxx
  new_clip
}
function teardown() {
  rm :_buf
  unset _clip
  unset _buf
}
function test_bad() {
  echo hellow world sailor | ins :_buf
  beg :_buf
  m m
  fwd :_buf; fwd :_buf
  mark_cut :_buf :_mark
  unset _mark
}
