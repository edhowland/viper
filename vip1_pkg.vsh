rem vip1_pkg.vsh the main meta package to load and start running Viper editor TODO: move this back to vip2_pkg.vsh
load_viper_paths
mpath=":{lhome}/packages/vip2.d/modules::{mpath}"
import start
load viper
import post
when_load vip2 { process_v viper; process_s viper; process_e viper; open_vip_files ; process_i viper; process_l viper; announce; meta vip }
