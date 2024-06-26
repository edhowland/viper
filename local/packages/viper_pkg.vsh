rem viper_pkg.vsh loads viper package
import option_processing
load_viper_paths
import keymaps
import edit
import pluginutils
function viper(fname) {
  o :fname
  vip
}
rem stub for the help command
function help(topic) {
   perr The help subsystem has not yet been loaded
   perr to load it enter "load help_base"
   perr then retry help :topic
}