# test_array.vsh tests various array methods

mod test_array {
function test_push() {
  mkarray /v/pus1; echo hello | push /v/pus1
  result=:(cat < /v/pus1)
  assert_eq :result hello
}
function test_pop() {
  mkarray /v/pop1; echo fubar | push /v/pop1
  result=:(pop /v/pop1)
  assert_eq :result fubar
}
function test_enq() {
  mkarray /v/enq1; echo revel | enq /v/enq1
  echo suprise | enq /v/enq1
  res1=:(pop /v/enq1)
  res2=:(pop /v/enq1)
  assert_eq :res1 revel
  assert_eq :res2 suprise
}
function test_deq() {
  mkarray /v/deq1; echo hello | push /v/deq1; echo world | push /v/deq1
  res1=:(deq /v/deq1)
  res2=:(deq /v/deq1)
  assert_eq :res1 hello
  assert_eq :res2 world
}
function test_peek() {
  mkarray /v/pek1
  for i in 1 2 { echo :i | push /v/pek1 }
  res1=:(peek /v/pek1)
  assert_eq :res1 1
  res2=:(peek -r /v/pek1)
  assert_eq :res2 2
}
function test_rotate() {
  mkarray /v/rot2
  for i in front middle back { echo :i | push /v/rot2 }
  rotate /v/rot2
  res1=:(peek /v/rot2)
  assert_eq :res1 middle
  rotate -r /v/rot2
  res2=:(peek /v/rot2)
  assert_eq :res2 front
}
function test_push_error() {
  echo hi | push /v/xjklm; assert_false :exit_status
}
function test_pop_error() {
  pop /v/no_array_actually_here; assert_false :exit_status
}
function test_peek_error() {
  peek /v/nothing_here; assert_false :exit_status
  peek -r /v/pek99; assert_false :exit_status
}
function test_rotate_error() {
  rotate /v/nil; assert_false :exit_status
  rotate -r /v/rot9; assert_false :exit_status
}
}

