rem viper_pkg.vsh loads viper package
import keymaps
mpath=":{lhome}/viper/modules::{mpath}"
import edit
function viper(fname) {
  o :fname
  _mode=viper apply fn_2
  meta vip
}
rem when_load { echo something might go herein }
