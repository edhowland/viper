rem Common Vish functions
function dircount(dir) {
  cond { test -e :dir } { echo 0 } else { (cd :dir; echo -n *) | wc -w }
}
function second(a, b) {
  echo :b
}