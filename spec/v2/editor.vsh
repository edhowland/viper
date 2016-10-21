function key.exists(key) { test -f "/v/modes/:{_mode}/:{key}" }
function apply.first(key) { exec "/v/modes/:{_mode}/:{key}" }
function apply.second(key) { exec "/v/views/:{_mode}/:{key}" }
function apply(ch) { (key.exists :ch || bell) && apply.first :ch | apply.second :ch }
function apply.times(count, key) { range=1..:{count}; for i in :range { apply.first :key } }
function ctrls() {ruby 'env[:out].puts ("a".."z").to_a.map {|e| "ctrl_#{e}" }.join(" ")' }
function mode.keys() { 
for i in :_ {
key=:(echo -n :i | xfkey)
bind :key &() { ins line :i } &() { echo -n :i } 
}
}
function printable() {
uc=A..Z lc=a..z nu=0..9 pu1='!../' pu2=':..@' pu3='[..`' pu4='{..~'
echo :lc :uc :nu :pu1 :pu2 :pu3 :pu4
}
function vip() {
basename :_buf
loop { fn=:(raw -|xfkey); eq :fn escape && break; apply :fn }
_loc=:pwd
global _loc
}
function handle.tab() {
apply.times :indent key_space
}
function handle.backtab() {
apply.times :indent key_backspace
}
function top.buffer() { eq :_buf :pwd }
function bottom.buffer() { test -f line && not { test -f nl } }
function insert.line() {
last=:(peek -r line/right | xfkey)
neq :last ctrl_j && echo | push line/right
(bottom.buffer && echo | appendtree) || echo | instree
cd nl 
 }
function move.start() { cat < line > line } 
function move.end() { cat < line > line/left; echo -n '' > line/right; eq ctrl_j :(peek -r line/left | xfkey) && move.left }
function move.down() {
move.start
cd nl
move.start
 cat < line 
}
function move.up() { move.start; top.buffer || cd ..; move.start; cat < line }
function move.left() { eq 0 :(wc < line/left) || pop line/left | enq line/right } 
function move.right() { eq 0 :(wc < line/right) || eq ctrl_j :(peek line/right | xfkey) || deq line/right | push line/left } 
function handle.return() {
insert.line
echo | push line/left
extract line/right | (cd nl; cat > line)
move.down
}
function col(op) { wc ":{op}" < line/left }
function move.bottom() { loop { cd nl || break }; move.end }
function move.top() { cd :_buf; move.start }
function del.left() { pop line/left }
function del.right() { deq line/right }
function lineno() { ruby "puts (':{pwd}'.split('/').count {|e| e == 'nl' } + 1)" }
function set.mark() {
echo :(lineno) :(col) > ":{_buf}/mark"
on ins { logger about to update mark; add.mark || logger no such mark here }
}
function unset.mark() { rm ":{_buf}/mark" }
function toggle.mark() { (test -f ":{_buf}/mark" && unset.mark) || set.mark }
function report.mark() { cat < ":{_buf}/mark" }
alias r=report.mark
function is.mark.set() { test -f ":{_buf}/mark" }
function add.mark() {
is.mark.set || logger no mark set && return false
_=:(report.mark)
shift l; shift c
neq :(lineno) :l && logger not the right line && return false
not { lte :(col) :c } && logger not less than col && return false
echo :l :(add :c 1) > ":{_buf}/mark"
}

