function assert_exec(f, message) {
  exec :f || raise "expected block or function to return true but returned :{exit_status} instead :{message}"
}
  function assert_exec_false(f,message) {
  exec :f &&  raise "expected block or function to return false but returned :{exit_status} instead :{message}"
}