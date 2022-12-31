rem process_i.vsh fn process_i gets buffer from stdin
function process_i(mod) {
   test -X "/v/options/:{mod}/actual/i" || return
   open standard_in
   touch ":{_buf}/.no_ask2_save"
}