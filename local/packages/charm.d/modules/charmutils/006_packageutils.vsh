rem package_utils.vsh various package related aliases and functions
function pn() { sh - "sed -E 's/(.+)_pkg.vsh/\1/'"

}
alias ldirs='ifs=":" for d in :old_lpath'
function ls_pkg(dir) {
   echo Packages in :dir
   (cd :dir; compgen -G *_pkg.vsh && ls *_pkg.vsh) | pn
}
function is_package_dir(dir) {
   suppress { ls *_pkg.vsh | pn }; pkg=:last_output
   test -z :pkg && return false
   test -d ":{pkg}.d/modules" && exec { echo :pkg; return true }
}
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
rem consider that argv always has charm.vsh and the command as the first 2 args
rem if there is a sub command and there will alays be one then you must subtract 3 from argc
function mandate_argc(req, act, msg) {
   real_argc=:(expr :act '-' 3)
   eq :real_argc :req || exec { perr ":{msg} requires :{req} arguments and you supplied :{real_argc}"; return false }
   return true
}
rem Given the source dir form the probable package/package_pkg.vsh filename
function pkg_src_file(src) {
   part=:(basename :src)
   echo ":{src}/:{part}_pkg.vsh"
}
rem Gets the possible destination package target package_pkg.vsh file if it exists
function pkg_dst_file(src, dst) {
   base_p=:(basename :src); dst_full=:(realpath :dst)
   echo ":{dst_full}/:{base_p}_pkg.vsh"
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

