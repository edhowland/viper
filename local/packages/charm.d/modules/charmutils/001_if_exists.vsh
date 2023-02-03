function if_dir(fname, yes, no) {
   cond { test -d :fname } { echo :yes } else { echo :no }
}
function if_file(fname, yes, no) {
   cond { test -X :fname } { echo :yes } else { echo :no }
}
function package_exists(pname) {
   ifs=":" for p in :lpath {
   test -X ":{p}/:{pname}_pkg.vsh" && exec { echo :p; return true }
   }
   return false
}