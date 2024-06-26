rem package help_base created from charm package new
pdir=":{__DIR__}/help_base.d"
mpath=":{pdir}/modules::{mpath}"
rem set up the help topic path in hpath
rem normally topics can be found in a package s  package.d/topics/category folder
hpath=":{pdir}/topics/general::{pdir}/topics/commands::{pdir}/topics/docs"
import helputils
