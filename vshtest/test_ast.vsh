mod test_ast {
   fn setup() {
      mkdir /v/scratch/test_ast
      cd /v/scratch/test_ast
      }
function test_boolean_or() {
  false || false
  assert_false :exit_status
}
function test_true() {
  true
  assert_true :exit_status
}
function test_or_true_and_false_returns_true() {
  false || true
  assert_true :exit_status
}
function test_or_returns_true_when_true_false() {
  true || false
  assert_true :exit_status
}
function test_true_or_true_is_true() {
  true || true
   assert_true :exit_status
}
function test_and_true_true_is_true() {
  true && true
  assert_true :exit_status
}
function test_false_and_true_is_false() {
  false && true
  assert_false :exit_status
}
function test_true_and_false_is_false() {
  true && false
  assert_false :exit_status
}
function test_false_and_false_is_false() {
  false && false
  assert_false :exit_status
}
function test_subshell_oldpwd() {
    mkdir t1/t2/t3
  (cd t1; (cd t2; (cd t3; assert_eq /v/scratch/test_ast/t1/t2 :oldpwd); assert_eq /v/scratch/test_ast/t1 :oldpwd); assert_eq  /v/scratch/test_ast :oldpwd)
}
}
