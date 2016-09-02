function goto.line(line) {
cd :_buf
_line=:(sub :line 1)
range=1..:{_line}
for l in :range { apply.first move_down }
}
function goto.col(col) {
apply.first move_shift_home
apply.times :col move_right
}
function mark(register) { touch ".m:{register}"; wc < line/left > ".m:{register}" }
function lineno() {
paths=:(ifs="/"; _=:pwd; shift _dummy; echo :_)
incr :(count &(a) { eq :a nl } :paths)
}
