rem process_files.vsh function to start all and open all files in argv
function open_argv() {
  cond { not { test -z :_buf } } {
    return false } { echo :argc | read z; zero :z } {
    open unnamed1 } else {
    for f in :(reverse :argv) { fopen :f }
  }
}