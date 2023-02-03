rem package functions like load
lpath=":{lhome}/packages::{lhome}/plugins"
test -d :chome && lpath=":{chome}/packages::{chome}/plugins::{lpath}"
mkdir /v/packages
function load(package) {
  pkg_src=:(package_path :package) || exec { perr No such package :package; return false }
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
