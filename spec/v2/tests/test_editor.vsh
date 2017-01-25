source ../scripts/editor.vsh
source ../scripts/marks.vsh
function test_cut_off_by_1() {
  open buf
  echo 0123456789 > :_buf
  fwd :_buf
  m _
  fwd :_buf; fwd :_buf; fwd :_buf; fwd :_buf
  mark_cut :_buf :_mark 
  assert eq 056789 :(cat < :_buf)
}
