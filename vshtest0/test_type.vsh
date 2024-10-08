function test_type_finds_function() {
  type assert | read result _dummy
  assert_eq :result 'function'
}
function test_defn_is_type_function() {
  defn my_foo &() { nop }
  type my_foo | read result _dummy
  assert_eq :result 'function'
}

