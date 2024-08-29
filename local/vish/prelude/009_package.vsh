# package functions like load
lpath=":{lhome}/packages::{lhome}/plugins"
cpackages=":{chome}/packages"; cplugins=":{chome}/plugins"
test -d :cplugins && lpath=":{cplugins}::{lpath}"; test -d :cpackages && lpath=":{cpackages}::{lpath}"
test -z :LPATH || lpath=":{LPATH}::{lpath}"
mkdir /v/packages
function load(package) {
  pkg_src=:(package_path :package) || exec { perr No such package :package; return false }
  mkdir "/v/packages/:{package}"
  source :pkg_src
  test -x "/v/packages/:{package}/on_load" && exec "/v/packages/:{package}/on_load"
}
function when_load(package, f) {
  mkdir "/v/packages/:{package}"; rem this might just be a mkdir -p
  store :f "/v/packages/:{package}/on_load"
}
rem This prepares to load our only one package so far viper
function load_viper_paths() {
  module_path edit > /dev/null || mpath=":{lhome}/viper/modules::{mpath}"; global mpath
}
