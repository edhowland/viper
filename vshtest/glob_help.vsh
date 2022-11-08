source map_pairs.vsh
source cpr_mimic.vsh
source zip.vsh
function run_glob(glob, fn1) {
  cd ":{vhome}/vshtest/tmp"
  sys=:(join ':' :(bash_glob :glob))
  phy=:(join ':' :(vish_glob :glob))
  vir=:(join ':' :(vfs_glob :glob))
  exec :fn1 :(ifs=':' zip ":{sys}" ":{phy}")
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
