source map_pairs.vsh
source cpr_mimic.vsh
source zip.vsh
function run_glob(glob, fn1) {
  cd ":{vhome}/vshtest/tmp"
  sys=:(join ':' :(bash_glob :glob))
  phy=:(join ':' :(vish_glob :glob))
nop perr  :glob "|:{phy}|"
  exec :fn1 :(ifs=':' zip ":{sys}" ":{phy}")
  cd -
}
function bash_glob(glob) {
  sh echo ":{glob}"
}
function vish_glob(glob) {
  src="echo :{glob}"
  eval :src
}