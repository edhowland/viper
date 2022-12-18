rem viper_pkg.vsh loads viper package
import keymaps
mpath=":{lhome}/viper/modules::{mpath}"
import edit
when_load viper { echo you are now in package viper.; echo  try opening a file with o filename and then meta vip }
