rem package.vsh handlers for loading packages like viper
rem TODO must make this search the :lpath for matching package
lpath=":{lhome}/packages"
mkdir /v/packages
function load(package) {
  pkg_src=":{lpath}/:{package}_pkg.vsh"
  test -X :pkg_src || exec { perr No such package :package; return false }
  mkdir "/v/packages/:{package}"
  source :pkg_src
  test -x "/v/packages/:{package}/on_load" && exec "/v/packages/:{package}/on_load"
}
function when_load(package, fn) {
  mkdir "/v/packages/:{package}"; rem this might just be a mkdir -p
  store :fn "/v/packages/:{package}/on_load"
}
rem This prepares to load our only one package so far viper
function load_viper_paths() {
  module_path edit > /dev/null || mpath=":{lhome}/viper/modules::{mpath}"; global mpath
}
