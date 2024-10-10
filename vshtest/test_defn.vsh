mod test_defn {
   fn setup() {
      function mys(x) {
  defn _mys { echo :x }
}
function a_fu(x) {
  defn a_bar &() { echo :x }
}
   }
function test_defn_can_take_a_block() {
  defn my_bar { echo bar }
  my_bar | read result
  assert_eq :result 'bar'
}
function test_defn_can_capture_closure() {
  x=7
  defn my_xxx &() { echo :x }
  my_xxx | read result
  assert_eq :result 7
}

function test_defn_can_capture_closure_from_inside_functions() {
  a_fu 88
  a_bar | read result
  assert_eq :result 88
}
function test_defn_takes_block_as_closure() {
  aa=66
  defn my_aa { echo :aa }
  my_aa | read result
  assert_eq :result 66
}

function test_defn_when_wrapped_in_outer_function_takes_parameter() {
  mys 78
  _mys | read result
  assert_eq :result 78
}
function test_defn_w_lambda_has_valid_name() {
  defn _fu1 &() { __fu2=:__FUNCTION_NAME__; global __fu2 }
  _fu1
  assert_eq :__fu2 _fu1
}
function test_defn_w_block_has_valid_name() {
  defn _fu3 { __fu3=:__FUNCTION_NAME__; global __fu3 }
  _fu3
  }
function test_defn_works_w_stored_lambda() {
  store &(x) { echo :x } /v/ecx
  retrv /v/ecx ecx
  defn echo_x :ecx
  echo_x foo | read result
  assert_eq :result foo
}
function test_defn_w_stored_block() {
store { echo bar } /v/bar
retrv /v/bar bar
defn echo_bar :bar
echo_bar | read result
assert_eq :result bar
}
}