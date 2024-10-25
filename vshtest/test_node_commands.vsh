mod test_node_commands {
function test_enq() {
  mkarray /v/arr
  echo hello | enq /v/arr
  result=:(cat < /v/arr)
  assert_eq :result hello
}
function test_deq() {
  mkarray /v/arr
  echo hello | enq /v/arr
  result=:(deq /v/arr)
  assert_eq :result hello
}
function test_push() {
  mkarray /v/arr
  echo hello | push /v/arr
  result=:(cat < /v/arr)
   assert_eq :result hello
}
function test_rotate_fwd() {
  mkarray /v/arr
  echo hello | enq /v/arr
  echo world | enq /v/arr
  rotate /v/arr
  result=:(cat < /v/arr)
  assert_eq ":{result}" 'hello world'
}
function test_rotate_back() {
  mkarray /v/arr
  echo 1 | push /v/arr
  echo 2 | push /v/arr
  echo 3 | push /v/arr
  rotate -r /v/arr
  result=:(cat < /v/arr)
  assert_eq ":{result}" '3 1 2'
}

}

