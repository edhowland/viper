rem test_source.vsh tests the source command
source vars1.vsh
function test_source_can_expose_defined_variables_to_source_caller() {
  assert_eq :vars1 VARS1
}