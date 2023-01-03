rem process_h.vsh allows for -h option to print help and then exit
function process_h(mod) {
   test -X "/v/options/:{mod}/actual/h" || return
echo Am I really that helpful
exit
}