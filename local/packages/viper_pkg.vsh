rem viper_pkg.vsh loads viper package
import keymaps
mpath=":{lhome}/viper/modules::{mpath}"
import edit
function viper(fname) {
  o :fname
  _mode=viper apply fn_2
  meta vip
}
when_load viper { echo you are now in package viper.; echo  try opening a file with viper filename }
