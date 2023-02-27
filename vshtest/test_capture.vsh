rem test_caputre.vsh does capture work ok
function test_capture_executes_within_current_scope() {
   capture { aa=11 } { nop }
   assert_eq :aa 11
}