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
function until.mark(blk, m) {
until.bottom { test -f ".m:{m}" && break; exec :blk }
}
function goto.mark(m) { until.mark { nop } :m }
function lineno() {
paths=:(ifs="/"; _=:pwd; shift _dummy; echo :_)
incr :(count &(a) { eq :a nl } :paths)
}
function between.lines(s, e) {
_saved=:pwd
goto.line :s
until.bottom { cat < line; eq :e :(lineno) && break }
cd :_saved
}
function between.marks(m) {
cd :_buf
_=:(until.bottom { test -f ".m:{m}" && lineno })
shift st; shift en
cd :_buf
between.lines :st :en
}
function copy.marks(m) {
between.marks :m | cat > /v/clip/0
}
function exclude.marks(m) {
cd :_buf
until.mark { cat < line } :m
apply.first move_down
goto.mark :m
until.bottom { cat < line } 
}
function cut.marks(m) {
cd :_buf
(exclude.marks :m) | cat > :_buf
}
