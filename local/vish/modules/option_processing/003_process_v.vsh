rem process_v.vsh print out Vish version and exit
function process_v(mod) {
  test -X "/v/options/:{mod}/actual/v" && exec { echo :version; exit 0 }
}