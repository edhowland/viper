rem module The command module for the charm program
pdir=":{__DIR__}/module.d"
lpath=":{pdir}::{lpath}"
import charmutils
sub=:(subcmd :argv)
test -z :sub ||exec {  load :sub; exit }
echo The module command lists known modules to the import Vish command.
echo The current value of the module search path mpath is 
echo :old_mpath
echo
echo Try issuing the following subcommand 
echo charm module ls
echo To list modules in a certain package issue the following help command
echo charm module help
