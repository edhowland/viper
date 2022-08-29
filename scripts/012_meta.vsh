function meta(fn) {
mkarray /v/meta
echo  :fn | push /v/meta
loop {
capture {
test -e /v/meta && break
:(peek -r /v/meta)
pop /v/meta | nop
} {
echo :last_exception | push /v/meta
} 
}
}
rem meta_modes helper function to print out all modes
function meta_modes() {
  ifelse { test -f /v/meta  } {cat < /v/meta  } { echo /v/meta does not exist }
  }
  