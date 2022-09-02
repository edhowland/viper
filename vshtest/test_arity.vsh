function test_arity1() {
  function foo_bar(a1) {
    ar=:_arity; global ar
    
  }
  foo_bar "X" "Y"
  assert_eq 1 :ar
  }
function test_arity_0() {
  
 function bar_foo() { ar=:_arity; global ar }
  bar_foo "X" "Y" "Z"
  assert_eq 0 :ar
}
function test_lambda0() {
  fa=&() { ar=:_arity; global ar }
  exec :fa "Z"
  assert_eq 0 :ar
}
function test_lambda1() {
  fb=&(a1) { ar=:_arity; global ar }
  exec :fb
  assert_eq 1 :ar
}
