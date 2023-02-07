rem if_exists.vsh various checks against extant paths and folders
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
vhome_bin=":{vhome}/bin"
function in_path() {
   ifs=":" for p in :PATH {
      eq :vhome_bin :p && return true
   }
   return false
}

