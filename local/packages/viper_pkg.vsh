rem viper_pkg.vsh loads viper package
load_viper_paths
import keymaps
import edit
function viper(fname) {
  o :fname
  _mode=viper apply fn_2
  meta vip
}
when_load viper { load vish_lang }
