rem dir commands mkdir rm cp mv
source asserts.vsh
mkdir /v/dir
function test_mkdir_1() {
  mkdir /v/dir/foo
  assert_exec { test -d /v/dir/foo } '/v/dir/foo not created'
}
function test_dir_mkdir_many() {
  mkdir /v/dir/mbar /v/dir/mbaz /v/dir/mspam
  for i in /v/dir/mbar /v/dir/mbaz /v/dir/mspam {
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
function test_dir_mv_1() {
  touch /v/dir/foo
  assert_exec { mv /v/dir/foo /v/dir/f9 } 'mv foo f9'
  assert_exec { test -f /v/dir/f9 } 'f9 does not exist after mv'
}
function test_dir_mv_to_dest2_folder() {
  touch /v/dir/foo; mkdir /v/dir/dest2
  assert_exec { mv /v/dir/foo /v/dir/dest2 } 'mv foo dest2/'
  assert_exec { test -f /v/dir/dest2/foo } 'dest2/foo does not exist after mv'
}
function test_dir_mv_many_to_dest3() {
  touch /v/dir/foo /v/dir/bar /v/dir/baz; mkdir /v/dir/dest3
  assert_exec { mv /v/dir/foo /v/dir/bar /v/dir/baz /v/dir/dest3 } 'mv foo bar baz dest3/'
  assert_exec { test -f /v/dir/dest3/foo && test -f /v/dir/dest3/bar && test -f /v/dir/dest3/baz } 'dest3/{foo,bar,baz} one did not exist after mv'
}
function test_dir_cp_one_from_folder_to_dot() {
mkdir /v/dir/dest4; touch /v/dir/dest4/yum
  assert_exec { (cd /v/dir; cp dest4/yum .) } 'attempts to cp dest4/yum .'
  assert_exec { test -f /v/dir/yum } '/v/dir/yum does not exist'
}
function test_dir_cp_2_files_to_child_dir() {
  mkdir /v/dir/d4; touch /v/dir/foo /v/dir/bar
  assert_exec { cp /v/dir/foo /v/dir/bar /v/dir/d4 } 'could not cp foo, bar to d4'
  assert_exec { test -f /v/dir/d4/foo && test -f /v/dir/d4/foo } 'd4/foo,bar did exist after cp'
}
function test_dir_cp_to_sibling_folder() {
  mkdir /v/dir/s5 /v/dir/d5; touch /v/dir/s5/abc /v/dir/s5/def
  assert_exec { (cd /v/dir/s5; cp abc def ../d5 ) } 'could not copy abc, def to sibling d5'
  assert_exec { (cd /v/dir/d5; test -f abc && test -f def) } 'd5/abc,def do not exist after cp from s5'
}
function test_cp_dot_blah_to_dot_dot_ram() {
  mkdir /v/dir/s6; echo hello > /v/dir/s6/blah
  assert_exec { (cd /v/dir/s6; cp ./blah ./ram) } 'cannot cp ./blah to ./ram'
  assert_exec { assert_eq :(cat < /v/dir/s6/blah) :(cat < /v/dir/s6/ram) } 'contents of s6/blah and s6/ram differ and should not'
}function test_dir_rm_one_object() {
  mkdir /v/dir/re; touch /v/dir/re/r1
  assert_exec { rm /v/dir/re/r1 } 'could not rm /v/dir/re/r1'
  assert_exec_false { test -f /v/dir/re/r1 } 're/r1 still exists after rm'
}
function test_dir_rm_2_objects() {
  mkdir /v/dir/re; touch /v/dir/re/r2 /v/dir/re/r3
  assert_exec { rm /v/dir/re/r2 /v/dir/re/r3 } 'could not rm r2 and r3'
  assert_exec_false { test -f /v/dir/re/r2 } 'r2 still exists after rm'
  assert_exec_false { test -f /v/dir/re/r3 } 'r3 still exists after rm'
}