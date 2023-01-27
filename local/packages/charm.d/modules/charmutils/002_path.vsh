rem path.vsh functions for exploring the system PATH and our internal paths
function match_path(pname, pth) {
   cond { test -z :pth } { return false }  { eq :pname :(ifs=":" first :pth) } {  return true } else { ifs=":" ofs=":" match_path :pname :(ifs=":" rest :pth); return :exit_status  }
}