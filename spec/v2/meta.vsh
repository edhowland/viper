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
function dodge_out() { exit }

