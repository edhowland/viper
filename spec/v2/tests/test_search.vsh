function setup_search() {
  clear /v/search | nop
}
function test_compose() {
  echo hello world > /v/search
  compose_srch_cmd srch_fwd
}
function test_search_can_take_embedded_space() {
  (echo hello world; echo bye donkey; echo goodbye sailor) | ins :_buf
  beg :_buf
  echo -n bye sailor | ins /v/search
  compose_srch_cmd srch_fwd
  exec :srch_cmd
  assert_true :exit_status
  result=:(line :_buf)
  assert eq 'goodbye sailor' ":{result}"
}
