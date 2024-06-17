rem uninstall packages will rm recursively package name if the package can be found in :lpath
source pkg_tool.vsh
function uninstall_it(_, pkg) {
   cond { pkg_file=:(which_pkg :pkg) } {
      echo Uninstalling :(basename :pkg_file) from :(pkg_root :pkg)
      test -d :(pkg_dir :pkg) && echo will also recursively remove the contents of :(pkg_dir :pkg)
      pkg_rm :pkg
   } else {
      perr :pkg does not appear to be a package install in your lpath
   }
}
uninstall_it :argv
