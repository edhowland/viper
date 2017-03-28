function test_between_w_middle_part() {
  open buf
  (echo 1;echo 2;echo 3;echo 4) | ins :_buf
  result=:(between xxx < :_buf)
  assert_eq ":{result}" '1 2 3 4'
}
function test_between_w_one_pattern() {
  open buf
  (echo 1;echo xxx;echo 3;echo 4) | ins :_buf
  result=:(between xxx < :_buf)
  assert_eq ":{result}" '3 4'
}
function test_between_w_2_patterns() {
  open buf
  (echo 1;echo xxx;echo 3;echo 4;echo xxx) | ins :_buf
  result=:(between xxx < :_buf)
  assert_eq ":{result}" '3 4'
}
function test_between_w_2_patterns_and_trailing_lines() {
   open buf
  (echo 1;echo xxx;echo 3;echo 4;echo xxx;echo 6;echo 7) | ins :_buf
  result=:(between xxx < :_buf)
  assert_eq ":{result}" '3 4' 
}
function test_between_w_empty_input() {
  result=:(echo -n | between xxx)
  assert test -z :result
}
