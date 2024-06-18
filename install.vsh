rem install.vsh will take its mandatory 2 arguments and cp -r the contents of arg1 to the directory listed in arg2
source pkg_tool.vsh
mandate_argc 2 :argc 'install.vsh' || exit 1
rem install_it is the main driver function for this sub package
function install_it(_, src, dst) {
   test -d :src || exec { perr :src must exist and be a directory containing at least 1 .vsh file; exit 1 }
   test -d :dst || exec { perr Destination directory :dst must exist and be a directory; exit 2 }
   dst_in_lpath :dst || exec { perr Destination directory must exist in the lpath Note the dash f option is not yet implemented; exit 3 }
   test -f :(pkg_dst_file :src :dst) && exec { echo Removing previously installed package  :src from :(realpath :dst); pkg_rm :src }
   pkg_cp :src :dst
}
   install_it :argv
