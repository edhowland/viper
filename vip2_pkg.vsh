rem vip2_pkg.vsh the main meta package to load and start running Viper editor
load_viper_paths
mpath=":{lhome}/packages/vip2.d/modules::{mpath}"
import start
load viper
import post
when_load vip2 { process_v viper; process_s viper; process_e viper; open_vip_files; process_l viper; announce; meta vip }
