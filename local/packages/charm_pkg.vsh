rem charm meta package
mpath=":{lhome}/packages/charm.d/modules::{mpath}"
old_lpath=:lpath
lpath=":{lhome}/packages/charm.d" load :(second :argv)
