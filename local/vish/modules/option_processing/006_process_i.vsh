# process_i.vsh fn process_i gets buffer from stdin
function process_i(mod) {
   test -X "/v/options/:{mod}/actual/i" || return false
   open standard_in
   touch ":{_buf}/.no_ask2_save"
   openf :_buf stdin
   beg :_buf
   rem reopen_stdin
}