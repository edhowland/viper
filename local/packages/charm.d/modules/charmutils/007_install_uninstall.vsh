rem functions for installing/uninstalling packages
function install_it(src, dst) {
   test -d :src || exec { perr :src must exist and be a directory containing at least 1 .vsh file; exit 1 }
   test -d :dst || exec { perr Destination directory :dst must exist and be a directory; exit 2 }
   dst_in_lpath :dst || exec { perr Destination directory must exist in the lpath Note the dash f option is not yet implemented; exit 3 }
   test -f :(pkg_dst_file :src :dst) && exec { echo Removing previously installed package  :src from :(realpath :dst); pkg_rm :src }
   pkg_cp :src :dst
}
function uninstall_it(pkg) {
   cond { pkg_file=:(which_pkg :pkg) } {
      echo Uninstalling :(basename :pkg_file) from :(pkg_root :pkg)
      test -d :(pkg_dir :pkg) && echo will also recursively remove the contents of :(pkg_dir :pkg)
      pkg_rm :pkg
   } else {
      perr :pkg does not appear to be a package install in your lpath; return false
   }
}