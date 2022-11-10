rem dir commands mkdir rm cp mv
function assert_exec(fn, message) {
  exec :fn || raise expected block or function to return true but returned :exit_status instead :message
}
mkdir /v/dir
function test_mkdir_1() {
  mkdir /v/dir/foo
  assert_exec { test -d /v/dir/foo } '/v/dir/foo not created'
}
function test_dir_mkdir_many() {
  mkdir /v/dir/bar /v/dir/baz /v/dir/spam
  for i in /v/dir/bar /v/dir/baz /v/dir/spam {
    assert_exec { test -d :i } ":{i} not created"
  }
}
function test_cp_1() {
  touch /v/dir/cp1.txt
  assert_exec { cp /v/dir/cp1.txt /v/dir/_cp1.txt } 'cp /v/dir/cp1.txt /v/dir/_cp1.txt'
  assert_exec { test -f /v/dir/cp1.txt && test -f /v/dir/_cp1.txt } 'both cp1.txt and _cp1.txt do not exist'
}
function test_dir_cp_many_to_dir() {
  mkdir /v/dir/dest1
  touch /v/dir/cp1.txt /v/dir/cp2.txt
  assert_exec { cp /v/dir/cp1.txt /v/dir/cp2.txt /v/dir/dest1 } 'cp cp1.txt cp2.txt to /v/dir/dest1 failed'
  assert_exec { test -f /v/dir/dest1/cp1.txt && test -f /v/dir/dest1/cp2.txt } 'after cp cp1, cp2 do not exist in /v/dir/dest1'
}