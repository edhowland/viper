rem viper_pkg.vsh loads viper package
load_viper_paths
import keymaps
import edit
function viper(fname) {
  o :fname
  _mode=viper apply fn_2
  meta vip
}
rem when_load viper { echo something might go herein }
