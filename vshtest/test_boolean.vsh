# test_boolean.vsh tests interaction of commands true and false and also exit_status
mod test_boolean {
function test_true_is_working_command() {
   x=true
   :x;assert_eq true :exit_status
}
function test_false_is_working_command() {
   z=false
   :z;assert_eq false :exit_status
}
function test_assert_exit_status_is_true() {
   nop; assert :exit_status
}
function test_assert_falseis_actually_false_exit_status() {
   false; assert_false :exit_status
}
}
