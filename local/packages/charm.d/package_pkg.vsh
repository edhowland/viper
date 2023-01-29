rem package subcommand of char
pdir=":{__DIR__}/package.d"
import charmutils
lpath=":{pdir}::{lpath}"
sub=:(subcmd :argv)
load :sub

