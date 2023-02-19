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
