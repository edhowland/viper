function meta(fn) {
mkarray /v/meta
echo  :fn | push /v/meta
for i in 1 2 3 4 5 6 {
capture {
test -e /v/meta && break
echo about to run :(peek -r /v/meta)
:(peek -r /v/meta)
pop /v/meta
} {
echo :last_exception | push /v/meta
echo about to goto :(peek -r /v/meta)
} 
}
}
function dodge_out() { exit }

