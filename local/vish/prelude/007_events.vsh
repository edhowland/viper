rem functions to handle event processors
mkdir /v/events/exit
store { nop } /v/events/exit/1
function run_exit_procs() {
  for e in /v/events/exit/* {  exec :e }
}
function at_exit(exe) {
  nxt=:(incr :(dircount /v/events/exit))
  store :exe "/v/events/exit/:{nxt}"
}