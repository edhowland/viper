rem charm meta package
 old_mpath=:mpath
mpath=":{lhome}/packages/charm.d/modules::{mpath}"
old_lpath=:lpath
lpath=":{lhome}/packages/charm.d" load :(second :argv)
