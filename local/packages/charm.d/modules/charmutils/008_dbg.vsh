rem REMOVEME TODO for testing only
function w_pkg(pkg) {
   pfile=":{pkg}_pkg.vsh"
   ifs=':' for p in :lpath {
      echo "trying to find :{pfile} in :{p}"
      test -f :pfile && exec { echo found it in :p; return true }
   }
   return false
   }
   