rem cpr_mimic.vsh mimics the actions of cp -r src/ dest without actually copying anything
function cpr_mimic(src, prefix) {
  cond { test -d :src } {
  mkdir ":{prefix}/:{src}"
  dirs=:(cd :src; filter &(x) { test -d :x } *)
  files=:(cd :src;filter &(x) { test -X :x } *)
  for f in :files { touch ":{prefix}/:{src}/:{f}" }
  (cd :src; for d in :dirs {  cpr_mimic :d ":{prefix}/:{src}" })
  } else { nop }
}
