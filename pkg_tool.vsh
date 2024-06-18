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
   pkg_d=:(pkg_dir :pkg)
   test -d :pkg_d && sh "rm -rf :{pkg_d}"
   rm :(which_pkg :pkg)
}
rem check for mandatory number of arguments presumably for some package sub command
function mandate_argc(req, act, msg) {
   rem Note that at least for this version argv 0 is the name of  the program itself and makes the argc one item bigger
   real_argc=:(expr :act '-' 1)
   eq :real_argc :req || exec { perr ":{msg} requires :{req} arguments and you supplied :{real_argc}"; return false }
   return true
}
rem Given the source dir form the probable package/package_pkg.vsh filename
function pkg_src_file(src) {
   part=:(basename :src)
   echo ":{src}/:{part}_pkg.vsh"
}
rem copies everything inside of src to dst recursively
function pkg_cp(src, dst) {
   full_dst=:(realpath :dst)
   sh "cd :{src}; cp -r * :{full_dst}"
}
rem is the target destination folder in the lpath
function dst_in_lpath(dst) {
   ifs=':' for d in :lpath {
      eq :(realpath :dst) :d && return true
   }
   return false
}

