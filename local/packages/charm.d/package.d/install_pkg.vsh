rem install the subcommand charm package install for possible path
pkg=:(ls *_pkg.vsh | pn)
arg=:(subarg :argv)
echo The current package :pkg will be installed in :arg
sh cp -R ":{pkg}.d/" :arg
cp ":{pkg}_pkg.vsh" :arg
