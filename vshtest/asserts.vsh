function assert_exec(fn, message) {
  exec :fn || raise expected block or function to return true but returned :exit_status instead :message
}
function assert_exec_false(fn,message) {
  exec :fn &&  raise expected block or function to return false but returned :exit_status instead :message 
}