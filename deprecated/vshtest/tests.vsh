function test_ok() {
  nop
}
function test_fail() {
   raise abort
}
function test_pass2() {
  eq 11 22
}
function test_bad() {
  assert test -f xyzzy
}
function test_ass_ok() {
  aa=10
  assert eq :aa 10
}
function test_ass_fail() {
  bb=11
  assert eq :bb 10
}
