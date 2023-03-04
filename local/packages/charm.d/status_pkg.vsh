rem displays the known status of the Viper ecosystem
import charmutils
pdir=":{__DIR__}/status.d"
mpath=":{pdir}/modules::{mpath}"
do_help=:(subcmd :argv)
test -z :do_help  || (eq :do_help help && exec { lpath=:pdir load help; exit })
import statlist
if_file ":{proj}/.vishrc" "There is already a .vishrc in your current project directory :{proj}" "There is no .vishrc in your current project :{proj}. It can be created from a template with charm config project"
echo
echo The current package and plugin search path for use with the load command is
echo :old_lpath
echo
echo The current module search path for use with the import command is
echo :old_mpath
echo
cond { has_git } { gitok="" } else { gitok="not" }
echo Git is :gitok installed on your system.
echo git will :(eq :no_use_git true && echo not) be used when charm package new is used to create a new package
echo This behaviour can be changed by setting the no_use_git variable to be true
echo in your "~/.vishrc" or by setting it in the "-e 'no_use_git=true;global no_use_git'"
cond { is_gitdir :proj } { gitdir="" } else { gitdir="not" }
echo Your current project directory is :gitdir a git repository.

