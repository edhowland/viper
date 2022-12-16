rem Common Vish functions
function dircount(dir) {
  cond { test -e :dir } { echo 0 } else { (cd :dir; echo -n *) | wc -w }
}
function second(a, b) {
  echo :b
}
rem find_first recurses over all remaining in list or using :ifs delimiter
function find_first(qterm, elem) {
  cond { test -z :elem } { return false } {
    eq :qterm :elem } { echo :elem; return true } else {
    find_first :qterm :_ }
}
rem module_path returns the first found matching module in :mpath else false
function module_path(mod,) {
  ifs=':' for p in :mpath {
    test -d ":{p}/:{mod}" && exec { echo ":{p}/:{mod}"; return true }
  }
  false
}