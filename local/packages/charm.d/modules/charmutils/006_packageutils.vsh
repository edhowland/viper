rem package_utils.vsh various package related aliases and functions
function pn() { sh - "sed -E 's/(.+)_pkg.vsh/\1/'"

}
alias ldirs='ifs=":" for d in :old_lpath'
function ls_pkg(dir) {
   echo Packages in :dir
   (cd :dir; ls *_pkg.vsh) | pn
}


