rem displays the known status of the Viper ecosystem
import charmutils
pdir=":{__DIR__}/status.d"
mpath=":{pdir}/modules::{mpath}"
do_help=:(subcmd :argv)
test -z :do_help  || (eq :do_help help && exec { lpath=:pdir load help; exit })
echo about to import statlist
import statlist
