function bell() { ruby 'print "\a"' }
function apply.first(key) { exec /v/modes/viper/:{key} }
function apply(ch) { exec /v/modes/viper/:{ch} | exec /v/views/viper/:{ch} }
function apply.times(count, key) { range=1..:{count}; for i in :range { apply.first :key } }
function trunc(ch) { ruby 'env[:out].puts args[1][1]' :ch }
function chars() { ruby "env[:out].puts (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).join(' ')"}
function puncts() { ruby 'a=((33..47).to_a + (58..64).to_a + (91..96).to_a + (123..126).to_a).map {|e| "_" + e.chr + "_" }.join(" "); env[:out].puts a' } 
function ctrls() {ruby 'env[:out].puts ("a".."z").to_a.map {|e| "ctrl_#{e}" }.join(" ")' }
alias av="ruby 'puts args.length'"
function handle.tab() {
apply.times :indent key_space
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
}
function view.ctrl() {
for i in :(ctrls) { store &() { bell } /v/views/viper/:{i} }
store &() { cat < line } /v/views/viper/ctrl_l
store &() { peek line/right | xfkey | xfkey -h } /v/views/viper/ctrl_j
store &() { echo -n tab } /v/views/viper/ctrl_i
}
function mode.move.keys() {
store &() { pop line/left | enq line/right } /v/modes/viper/move_left
store &() { deq line/right | push line/left } /v/modes/viper/move_right
store &() { apply.first move_shift_home; cd .. } /v/modes/viper/move_up
store &() { apply.first move_shift_home; cd nl } /v/modes/viper/move_down
store { cd :_buf } /v/modes/viper/move_shift_pgup
store &() { loop { cd nl || break }; echo -n "hi" } /v/modes/viper/move_shift_pgdn
store &() { cat < line > line } /v/modes/viper/move_shift_home
store &() { loop { peek line/right >/dev/null || break; apply.first move_right } } /v/modes/viper/move_shift_end
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
function install() { 
mode.keys.alpha
mode.keys.punct
view.keys.alpha
view.keys.punct
mode.keys.space
view.keys.space
mode.ctrl
view.ctrl
store &() { cat } /v/modes/viper/unknown
store &() { bell } /v/views/viper/unknown
mode.move.keys
view.move.keys
}
function vip() { loop { fn=:(raw -|xfkey); eq :fn ctrl_q && break; apply :fn } }
alias buffer="basename :_buf"
install
