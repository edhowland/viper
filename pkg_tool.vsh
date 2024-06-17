rem functions for working with packages and folders of packages
rem returns the full path of the found package in lpath or else false
function which_pkg(pkg) {
   pname=":{pkg}_pkg.vsh"
   ifs=':' for p in :lpath {
      cand=":{p}/:{pname}"
      test -f :cand && exec { echo :cand; return true }
   }
   return false
}
rem echos the found package root if found
function pkg_root(pkg) {
   cond { which_pkg :pkg > /dev/null  } {
      dirname :(which_pkg :pkg)
   } else { echo '' }
}
rem the possible pkg.d that might exist
function pkg_dir(pkg) {
   pkg_root=:(pkg_root :pkg)
   echo ":{pkg_root}/:{pkg}.d"
}
rem performs a hard remove of the found package
function pkg_rm(pkg) {
   rm :(which_pkg :pkg)
   pkg_d=:(pkg_dir :pkg); test -d :pkg_d && sh "rm -rf :{pkg_d}"
}
