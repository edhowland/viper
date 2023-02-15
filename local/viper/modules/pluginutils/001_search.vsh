rem search.vsh fn locate_plugins returns list of found plugins
function pn() { sh - "sed -E 's/(.+)_pkg.vsh/\1/'" }
function ls_plugins(dir) {
   (cd :dir; ls *_pkg.vsh | pn)
}
function locate_plugins() {
   ifs=":" for p in :lpath {
      eq :(basename :p) plugins && ls_plugins :p
   }
}