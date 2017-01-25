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
  raise no such file
}
