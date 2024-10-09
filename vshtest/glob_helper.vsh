# source map_pairs.vsh
function map_pairs(fn) {
  cond { test -z :_ } { return } else { shift a b; exec :fn :a :b; map_pairs :fn :_ }
}
# source cpr_mimic.vsh
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


# source zip.vsh
cmdlet zip '{ out.puts args[0].split(locals[:ifs]).zip(args[1].split(locals[:ifs])).join(locals[:ofs]) }'

function run_glob(glob, fn1) {
  cd ":{vhome}/vshtest/tmp"
  sys=:(join ':' :(bash_glob :glob))
  phy=:(join ':' :(vish_glob :glob))
  vir=:(join ':' :(vfs_glob :glob))
  exec :fn1 :(ifs=':' zip ":{sys}" ":{phy}")
  exec :fn1 :(ifs=':' zip ":{sys}" ":{vir}")
  cd -
}
function bash_glob(glob) {
  sh echo ":{glob}"
}
function vfs_glob(glob) {
   src="echo :{glob}"
  (cd /v/glob/tmp; eval :src)
}
function vish_glob(glob) {
  src="echo :{glob}"
  eval :src
}
cd ":{vhome}/vshtest"
mkdir /v/glob
cpr_mimic tmp /v/glob
