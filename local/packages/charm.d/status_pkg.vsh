rem status a subcommand of the charm app
rem displays the known status of the Viper ecosystem
echo you are viewing the Viper ecosystem status
import charmutils
cond { test -X ":{lhome}/etc/no-viper-welcome-banner" } { will=not } else { will='' }
echo When Viper starts with no files to edit it will :will display the Welcome banner
echo You can view or change this behaviour with charm welcome "[remove] [restore]"
echo
if_dir ":{chome}" "The config folder exists in :{chome}" "There is no local configin :{chome}. It can be created with charm config create."
if_file ":{HOME}/.vishrc" "You already have a local .vishrc in your home directory" "There is no local .vishrc in your home directory. It can be created with charm config vishrc which create one from a template"
if_file ":{proj}/.vishrc" "There is already a .vishrc in your current project directory :{proj}" "There is no .vishrc in your current project :{proj}. It can be created from a template with charm config project"
match_path ":{vhome}/bin" :PATH || cat ":{__DIR__}/status.d/path.md"
echo
echo The current package and plugin search path for use with the load command is
echo :old_lpath
echo
echo The current module search path for use with the import command is
echo :mpath
echo
cond { has_git } { gitok="" } else { gitok="not" }
echo Git is :gitok installed on your system.
cond { is_gitdir :proj } { gitdir="" } else { gitdir="not" }
echo Your current project directory is :gitdir a git repository.

