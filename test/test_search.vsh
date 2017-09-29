function test_embed() {
  clear :_buf
  (echo hello world; echo bye donkey; echo goodbye sailor) | ins :_buf
  beg :_buf
  clear /v/search
  echo -n bye sailor | ins /v/search
  unset srch_cmd
  compose_srch_cmd srch_fwd
  assert_not_empty :srch_cmd 
  exec :srch_cmd
  assert_true :exit_status
  result=:(line :_buf)
  assert eq 'goodbye sailor' ":{result}"
}


