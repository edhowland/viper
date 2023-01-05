rem search.vsh new search functions
function do_search(direction) {
  cond { eq :direction fwd } {
    pattern=:(getline search); srch_fwd :_buf ":{pattern}"
  } { eq :direction back } {
    pattern=:(getline "search back"); srch_back :_buf ":{pattern}"
 } else { perr No such search direction :direction; return false }
  srch_dir=:direction; global srch_dir; srch_pattern=":{pattern}"; global srch_pattern
  line :_buf
}
function search_again() {
  test -z :srch_dir && exec { perr You have never searched before in this session. Try either control f or control r first; return false }
  meth="srch_:{srch_dir}"
  :meth :_buf ":{srch_pattern}"
  line :_buf
}