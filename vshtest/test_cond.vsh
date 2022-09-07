function test_single_clause() {
  a=1
  cond { false } { a=2   }
  assert_eq :a 1
}
function test_single_clause_is_true() {
  b=1
  cond { true } { b=2 }
  assert_eq :b 2
}
function test_cond__with_2_clauses() {
  c=1
  cond { true } { c=2 } { true } { c=3 }
  assert_eq :c 2
  }
  function test_2_clauses_2nd_fires() {
  d=1
  cond { false } { d=2 } { true } { d=3 }
  assert_eq :d 3
}
function test_cond_2_clauses_no_fires() {
  e=1
  cond { false } { e=2 } {
    false } { e=3 }
  assert_eq :e 1
}
function test_cond_w_1_clause_w_else_first_fires() {
  a=1
  cond { true } { a=2 } else { a=3 }
  assert_eq :a 2
}
function test_2_clauses_with_else_but_first_fires() {
  f=1
  cond { true } { f=2 } {
    false } { f=3 } else {
    f=4
  }
  assert_eq :f 2
}
function test_3_clauses_true_false_true_only_first_should_fire() {
  a=1
  cond { true } { a=2 } { false } { a=3 } { true } { a=4 }
  assert_eq :a 2
}
function test_cond_w_2_true_clauses_and_else_only_first_fires() {
  a=1
  cond { true } { a=2 } { true } { a=3 } else { a=4 }
  assert_eq :a 2
}
function test_cond_returns_the_result_of_last_true_predicate() {
  cond { true } { nop } { false } { nop }; assert_true :exit_status
}
function test_cond_true_false_else_first_fires() {
  a=1
  cond { false } { a=2 } { false } { a=3 } else { a=4 }
  assert_eq :a 4
}
