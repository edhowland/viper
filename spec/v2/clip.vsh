echo "goto.line: Moves cursor to requested line. Usage: goto.line line_number" | desc goto.line
function goto.line(line) {
cd :_buf
_line=:(sub :line 1)
range=1..:{_line}
for l in :range { apply.first move_down }
}
echo "goto.col: Positions cursor at requested column (0-based). Usage: goto.col column_number" | desc goto.col
function goto.col(col) {
apply.first move_shift_home
apply.times :col move_right
}
echo "mark: Places a mark on current line. Usage: mark register  ... where register is any string. Used for marking selections for cut, cut text." | desc mark
function mark(register) { touch ".m:{register}"; wc < line/left > ".m:{register}" }
function until.mark(blk, m) {
until.bottom { test -f ".m:{m}" && break; exec :blk }
}
echo "goto.mark: Positions cursor at requested marked register. Usage: goto.mark register ... where register is some previously marked line." | desc goto.mark
function goto.mark(m) { until.mark { nop } :m }
echo "lineno: Outputs current line number of current buffer. Usage: lineno" | desc lineno
function lineno() {
paths=:(ifs="/"; _=:pwd; shift _dummy; echo :_)
incr :(count &(a) { eq :a nl } :paths)
}
echo "between.lines: Outputs text of current buffer between lines. Usage: between.lines start end. Where start is first line and end is last line to output" | desc between.lines
function between.lines(s, e) {
_saved=:pwd
goto.line :s
until.bottom { cat < line; eq :e :(lineno) && break }
cd :_saved
}
echo "between.marks: Outputs text between lines marked with register. Usage: between.marks register ... where register is some previous marked region." | desc between.marks
function between.marks(m) {
cd :_buf
_=:(until.bottom { test -f ".m:{m}" && lineno })
shift st; shift en
cd :_buf
between.lines :st :en
}
echo "copy.marks: Copies lines between marks to clipboard. Usage: copy.marks  . Bound to Control C" | desc copy.marks
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
echo "cut.marks: Extracts lines between marked section and copies to clipboard. Usage: cut.marks  .  Bound to Ctrl X" | desc cut.marks
function cut.marks(m) {
copy.marks :m
cd :_buf
(exclude.marks :m) | cat > :_buf
}
echo "put: Outputs contents of clipboard. Usage: put" | desc put
function put() { cat < /v/clip/0 }
echo "paste: Pastes contents of clipboard into current buffer. Usage: paste . Bound to Control v" | desc paste
function paste() { (bottom.buffer && put | appendtree) || put | instree }


