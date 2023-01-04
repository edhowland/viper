rem vip_pkg.vsh the main meta package to load and start running Viper editor
load_viper_paths
mpath=":{lhome}/packages/vip.d/modules::{mpath}"
import start
load viper
import post
when_load vip { process_h viper; process_v viper; process_s viper; process_e viper; open_vip_files ; process_i viper; process_l viper; _mode=viper apply fn_2; vip  }
