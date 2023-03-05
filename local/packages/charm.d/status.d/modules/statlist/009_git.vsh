rem git.vsh status checks on git stuff everywhere
cond { has_git } { gitok="" } else { gitok="not" }
echo Git is :gitok installed on your system.
echo git will :(eq :no_use_git true && echo not) be used when charm package new is used to create a new package
echo This behaviour can be changed by setting the no_use_git variable to be true
echo in your "~/.config/vish/rc" or by  when running most charm commands by   setting  the -e option the "-e 'no_use_git=true;global no_use_git'"
cond { is_gitdir :proj } { gitdir="" } else { gitdir="not" }
echo Your current project directory is :gitdir a git repository.

