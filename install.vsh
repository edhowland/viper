rem install.vsh will take its mandatory 2 arguments and cp -r the contents of arg1 to the directory listed in arg2
source pkg_tool.vsh
mandate_argc 2 :argc 'install.vsh' || exit 1
function pkg_name(fpath) {
   x=''
   ifs='_' for i in :fpath { test -z :x && x=:i }
   echo :x
}
rem install_it is the main driver function for this sub package
function install_it(_, src, dst) {
   cond { which_pkg :src > /dev/null } { echo Removing previously installed :src ; pkg_rm :src }
   }
   install_it :argv
