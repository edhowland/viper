rem import set paths and the import module_name function
mpath=":{lhome}/vish/modules"
function import(module) {
  rem store the current pwd so importers like init/on_import.vsh can load from here
  latest_wd=:pwd; global latest_wd
  cd ":{mpath}/:{module}"
  for s in ???_*.vsh { source :s }
  test -X on_import.vsh && source on_import.vsh
  suppress { cd - }
}
