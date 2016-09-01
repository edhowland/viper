function top.buffer() { eq :_buf :pwd }
function bottom.buffer() { test -f line && not { test -f nl } }
function until.bottom(fn) { loop { exec :fn; bottom.buffer && break; apply.first move_down } }
function key.exists(key) { test -f "/v/modes/:{_mode}/:{key}" }
function bind(key, fn1, fn2) { store :fn1 /v/modes/:{_mode}/:{key}; store :fn2 /v/views/:{_mode}/:{key} }
function apply.first(key) { exec "/v/modes/:{_mode}/:{key}" }
function apply.second(key) { exec "/v/views/:{_mode}/:{key}" }
function apply(ch) { (key.exists :ch || bell) && apply.first :ch | apply.second :ch }
function apply.times(count, key) { range=1..:{count}; for i in :range { apply.first :key } }
function find.right(pattern) { loc=:(indexof :pattern < line/right) && global loc }
function find.forward(pattern) {
_=:(until.bottom { indexof :pattern < line/right && echo :pwd && break })
test -z :_ && echo :pattern not found && return false
shift _pos; shift _dir
cd :_dir
apply.times :_pos move_right
cat < line/right
find_last=&() { find.forward :pattern }; global find_last
}
function read.word() {
grep -o '/(\w+)/' < line/right
}
function yank.word() { read.word > /v/clip/0/line }
function find.blank() {
b=:(indexof ' ' < line/right)
r=1..:{b}
for i in :r { apply.first move_right }
}
function find.word() {
find.blank
a=:(indexof '/(\w+)/' < line/right)
r=1..:{a}
for i in :r { apply.first move_right }
grep -n -o '/(\w+)/' < line/right 
}
function delete.word() {
start=:(wc < line/left)
find.blank
fin=:(wc < line/left)
range=":{start}..:{fin}"
for i in :range { apply.first key_backspace | nop }
}
function trunc(ch) { ruby 'env[:out].puts args[1][1]' :ch }
function chars() { ruby "env[:out].puts (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).join(' ')"}
function puncts() { ruby 'a=((33..47).to_a + (58..64).to_a + (91..96).to_a + (123..126).to_a).map {|e| "_" + e.chr + "_" }.join(" "); env[:out].puts a' }
function ctrls() {ruby 'env[:out].puts ("a".."z").to_a.map {|e| "ctrl_#{e}" }.join(" ")' }
alias av="ruby 'puts args.length'"
function handle.tab() {
apply.times :indent key_space
}
function handle.return() {
(apply.first ctrl_o)
echo | push line/left
extract line/right | (cd nl; cat > line)
apply move_down
}
function mode.keys.alpha() { for i in :(chars) { store &() { echo -n :i | push line/left } /v/modes/viper/key_:{i} } }
function view.keys.alpha() { for i in :(chars) { store &() { echo -n :i  } /v/views/viper/key_:{i} } }
function view.keys.punct() { for i in :(puncts) { key=:(trunc :i); fname=:(echo -n :key | xfkey); store &() { echo -n :key } /v/views/viper/:{fname} } }
function mode.keys.punct() { for i in :(puncts) { key=:(trunc :i); fname=:(echo -n :key | xfkey); store &() { echo -n :key | push line/left } /v/modes/viper/:{fname} } }
function mode.keys.space() {
fname=:(echo -n ' '|xfkey); store &() { echo -n ' '| push line/left } /v/modes/viper/:{fname} 
store &() { pop line/left } /v/modes/viper/key_backspace
store &() { deq line/right } /v/modes/viper/key_delete
store &() { apply.times :indent key_backspace } /v/modes/viper/key_backtab
}
function view.keys.space() {
fname=:(echo -n ' '|xfkey); store &() { echo -n space } /v/views/viper/:{fname}
store &() { echo -n delete :(xfkey|xfkey -h) } /v/views/viper/key_backspace
store &() { echo -n delete :(xfkey|xfkey -h) } /v/views/viper/key_delete
store &() { echo -n back tab } /v/views/viper/key_backtab
}
function mode.ctrl() {
for i in :(ctrls) { store &() { nop } /v/modes/viper/:{i} }
store &() { handle.tab } /v/modes/viper/ctrl_i
store &() { last=:(peek -r line/right | xfkey); neq :last ctrl_j && echo | push line/right;  echo | instree; cd nl } /v/modes/viper/ctrl_o
store &() { handle.return } /v/modes/viper/ctrl_m
store { wc < line/left } /v/modes/viper/ctrl_k
store &() { spy line/left } /v/modes/viper/ctrl_k
store { buffers=:(rotate :buffers); global buffers; tmp=":{buffers}"; shift -s tmp _buf; global _buf; cd :_buf; basename :_buf } /v/modes/viper/ctrl_t
store &() { yank 1 } /v/modes/viper/ctrl_y
store &() { paste } /v/modes/viper/ctrl_v
store &() { apply.first ctrl_y; delete.line } /v/modes/viper/ctrl_d
store { ruby 'raise VirtualMachine::ExitCalled' } /v/modes/viper/ctrl_q
store { save } /v/modes/viper/ctrl_s
}
function view.ctrl() {
for i in :(ctrls) { store &() { bell } /v/views/viper/:{i} }
store &() { cat < line } /v/views/viper/ctrl_l
store &() { peek line/right | xfkey | xfkey -h } /v/views/viper/ctrl_j
store &() { echo -n tab } /v/views/viper/ctrl_i
store &() { cat < line } /v/views/viper/ctrl_o
store &() { cat } /v/views/viper/ctrl_m
store &() { cat } /v/views/viper/ctrl_k
store &() { wc -n } /v/views/viper/ctrl_k
store &() { echo buffer is now :(cat) } /v/views/viper/ctrl_t
store &() { echo -n 1 line yanked } /v/views/viper/ctrl_y
store &() { echo -n paste } /v/views/viper/ctrl_v
store &() { echo -n one line deleted } /v/views/viper/ctrl_d
store { nop } /v/views/viper/ctrl_q
store { echo -n :(apply.first fn_2) saved } /v/views/viper/ctrl_s
}
function mode.meta() {
store { nop } /v/modes/viper/meta_d
}
function view.meta() {
store { echo -n delete; chg.mode delete } /v/views/viper/meta_d
}
function mode.fn.keys() {
store { basename :_buf } /v/modes/viper/fn_2
}
function view.fn.keys() {
store &() { cat } /v/views/viper/fn_2
}
function mode.move.keys() {
store &() { ll=:(cat < line/left); test -z :ll || pop line/left | enq line/right } /v/modes/viper/move_left
store &() { ch=:(peek line/right | xfkey); eq ctrl_j :ch || deq line/right | push line/left } /v/modes/viper/move_right
store { apply.first move_shift_home; top.buffer || cd .. } /v/modes/viper/move_up
store &() { apply.first move_shift_home; cd nl; apply.first move_shift_home } /v/modes/viper/move_down
store { cd :_buf } /v/modes/viper/move_shift_pgup
store &() { loop { cd nl || break }; echo -n "hi" } /v/modes/viper/move_shift_pgdn
store &() { cat < line > line } /v/modes/viper/move_shift_home
store &() { loop { ch=:(peek line/right | xfkey); eq ctrl_j :ch && break; apply.first move_right } } /v/modes/viper/move_shift_end
}
function view.move.keys() {
store &() { peek line/right | xfkey | xfkey -h } /v/views/viper/move_left
store &() { peek line/right | xfkey | xfkey -h } /v/views/viper/move_right
store &() { cat < line } /v/views/viper/move_up
store &() { cat < line } /v/views/viper/move_down
store &() { echo -n start of document } /v/views/viper/move_shift_pgup
store  { echo -n end of document   } /v/views/viper/move_shift_pgdn
store &() { echo -n start of line } /v/views/viper/move_shift_home
store &() { echo -n end of line } /v/views/viper/move_shift_end
}
function delete.line() { cd ..; mv nl/nl _nl; rm nl; mv _nl nl; cd nl }
function delete.mode.keys() {
store { delete.line } /v/modes/delete/key_d
store { cat < line/right > /v/clip/0; echo > line/right } /v/modes/delete/move_shift_end
}
function delete.view.keys() {
store { echo -n line; restore.mode } /v/views/delete/key_d
store { echo -n to end of line; restore.mode  } /v/views/delete/move_shift_end
}
source search.vsh
function install() { 
mode.keys.alpha
mode.keys.punct
view.keys.alpha
view.keys.punct
mode.keys.space
view.keys.space
mode.ctrl
view.ctrl
mode.meta
view.meta
mode.fn.keys
view.fn.keys
delete.mode.keys
delete.view.keys
store &() { cat } /v/modes/viper/unknown
store &() { bell } /v/views/viper/unknown
mode.move.keys
view.move.keys
bind ctrl_w { find.word } { cat }
_mode=delete bind key_w { restore.mode; delete.word } { echo -n word deleted }
setup.search
}
function vip() {
basename :_buf
loop { fn=:(raw -|xfkey); eq :fn escape && break; apply :fn }
_loc=:pwd
global _loc
}
alias i="cd :_loc; vip"
function chg.mode(m) { _oldmode=:_mode; global _oldmode; _mode=:m; global _mode }
function restore.mode() { _mode=:_oldmode; global _mode }
alias buffer="basename :_buf"
install
function open.all() {
for f in :argv { open :f }
buffers=:(map &(x) { echo -n "/v/buf/:{x} " } :argv)
global buffers
tmp=":{buffers}"
shift -s tmp _buf; global _buf
cd :_buf
}
function pager(lines) {
range=1..:{lines}
cat < line
for i in :range { apply move_down }
}
page_lines=9
global page_lines
bind ctrl_p { pager :page_lines } { cat }
