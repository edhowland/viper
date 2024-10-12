function test_between_w_middle_part() {
  open buf
  (echo 1;echo 2;echo 3;echo 4) | ins :_buf
  # result=:(between xxx < :_buf)
  # assert_eq ":{result}" '1 2 3 4'
}
