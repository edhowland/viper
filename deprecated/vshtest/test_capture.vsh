rem test_caputre.vsh does capture work ok
function test_capture_executes_within_current_scope() {
   capture { aa=11 } { nop }
   assert_eq :aa 11
}
function test_capture_sets_last_exception() {
   capture { raise I_am_the_walrus } { test -z last_exception }
   assert_eq :last_exception I_am_the_walrus
}
function test_capture_ensure_is_in_current_scope() {
   capture { raise food } { nop } { bar=baz }
   assert_eq :bar  baz
}
function test_capture_ensure_always_runs() {
   capture { nop } { nop } { baz=foo; global baz }
   assert_eq :baz foo
}
function test_capture_rescue_does_not_run_when_no_exception() {
   capture { nop } { touch /v/test_capture_no_rescue } { nop }
   test -X /v/test_capture_no_rescue && raise rescue_called
}