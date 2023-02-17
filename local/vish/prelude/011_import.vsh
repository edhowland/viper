rem import set paths and the import module_name function
mpath=":{lhome}/vish/modules"
test -z :MPATH || mpath=":{MPATH}::{mpath}"
function import(module) {
  latest_wd=:pwd; global latest_wd
  pth=:(module_path :module) || exec { perr No such module :module; return false }
  test -e :pth && exec { perr module :pth cannot be empty; return false }
  mkdir "/v/modules/:{module}"
  cd :pth
  suppress { ls ???_*.vsh } && for s in ???_*.vsh { source :s; cd :pth }
  test -X on_import.vsh && source on_import.vsh
cd :latest_wd
}
