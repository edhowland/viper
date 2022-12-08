rem import set paths and the import module_name function
mpath=":{lhome}/vish/modules"
function import(module) {
  cd ":{mpath}/:{module}"
  for s in ???_*.vsh { source :s }
  suppress { cd - }
}
