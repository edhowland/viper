rem displays the known status of the Viper ecosystem
import charmutils
pdir=":{__DIR__}/status.d"
do_help=:(subcmd :argv)
test -z :do_help  || (eq :do_help help && exec { lpath=:pdir load help; exit })
echo you are viewing the Viper ecosystem status
cond { in_path } { echo Your Viper and Vish  and ivsh and charm  commands are already in your PATH } else { cat ":{pdir}/path.md" }
cond { test -X ":{lhome}/etc/no-viper-welcome-banner" } { will=not } else { will='' }
echo When Viper starts with no files to edit it will :will display the Welcome banner
echo You can view or change this behaviour with charm welcome "[remove] [restore]"
echo
if_dir ":{chome}" "The config folder exists in :{chome}" "There is no local configin :{chome}. It can be created with charm config create."
if_file ":{HOME}/.vishrc" "You already have a local .vishrc in your home directory" "There is no local .vishrc in your home directory. It can be created with charm config vishrc which create one from a template"
if_file ":{proj}/.vishrc" "There is already a .vishrc in your current project directory :{proj}" "There is no .vishrc in your current project :{proj}. It can be created from a template with charm config project"
echo
echo The current package and plugin search path for use with the load command is
echo :old_lpath
echo
echo The current module search path for use with the import command is
echo :mpath
echo
cond { has_git } { gitok="" } else { gitok="not" }
echo Git is :gitok installed on your system.
echo git will :(eq :no_use_git true && echo not) be used when charm package new is used to create a new package
echo This behaviour can be changed by setting the no_use_git variable to be true
echo in your "~/.vishrc" or by setting it in the "-e 'no_use_git=true;global no_use_git'"
cond { is_gitdir :proj } { gitdir="" } else { gitdir="not" }
echo Your current project directory is :gitdir a git repository.

