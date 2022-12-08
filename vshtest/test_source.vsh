rem test_source.vsh tests the source command
source vars1.vsh
function test_source_can_expose_defined_variables_to_source_caller() {
  assert_eq :vars1 VARS1
}
function test_source_embedded_in_a_function_still_exports_global_variables() {
  function do_source_9() { source foo_var.vsh }
  do_source_9
  assert_eq :vfoo foo
}
function test_outer_source_gets_its_file_variable_preserved_after_source_inner_source() {
  source outer_source.vsh
}