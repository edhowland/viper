rem process_h.vsh allows for -h option to print help and then exit
function process_h(mod) {
   test -X "/v/options/:{mod}/actual/h" || return
   test -X "/v/options/:{mod}/help/banner" && cat < "/v/options/:{mod}/help/banner"
   (cd "/v/options/:{mod}"
      for o in :(cat < help/order) {
         opt=:o; echo -n "  -:{opt}: "; test -X "help/:{opt}" && cat "help/:{opt}"; echo
      })
exit
}