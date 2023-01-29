function if_dir(fname, yes, no) {
   cond { test -d :fname } { echo :yes } else { echo :no }
}
function if_file(fname, yes, no) {
   cond { test -X :fname } { echo :yes } else { echo :no }
}