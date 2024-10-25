#!/usr/bin/env vish
# vrun.vsh the main meta package to load and start running Viper editor and run a single command
load_viper_paths
mpath=":{lhome}/packages/vip.d/modules::{mpath}"
import start
load viper
# import post

# Run a command in Viper without starting the command loop
fn  main(cmd) {
   :cmd :_
}


