mkbuf /v/command
mkarray /v/command/bufstack
mkarray /v/command/modestack
_mode=command mode_keys :(printable)
function com() {
true;_status=:exit_status;global _status
loop {
echo -n ":{prompt}2"
fin /v/command
_mode=command _buf=/v/command loop { 
fn=:(raw -|xfkey)
apply :fn 
eq :fn ctrl_m && break
}
(eq "exit" ":{cmd}") && exit
(eq 'vip' ":{cmd}") && _mode=viper apply fn_2 && break
capture { echo; vsh -e :_status ":{cmd}" } { perr caught exception ':' :last_exception } { _status=:exit_status; global _status }
}
}
kname=:(echo -n ' '|xfkey)
_mode=command bind :kname { ins :_buf ' ' } { echo -n space }
_mode=command bind move_down { capture { down :_buf; line :_buf } } { cat }
_mode=command bind move_up { capture { up :_buf; back_of_line :_buf; line :_buf } } { cat }
_mode=command bind move_left { back :_buf } { at :_buf }
_mode=command bind move_right { fwd :_buf } { at :_buf }
_mode=command bind ctrl_j { nop } { at :_buf }
_mode=command bind ctrl_k { nop } { col :_buf }
_mode=command bind ctrl_l { nop } { line :_buf }
_mode=command bind key_backspace { del :_buf } { echo -n delete :(xfkey | xfkey -h) }
_mode=command bind key_delete { del_at :_buf } { echo -n delete :(xfkey | xfkey -h) }
_mode=command bind move_shift_home { front_of_line :_buf } { at :_buf }
_mode=command bind move_shift_end { back_of_line :_buf } { at :_buf }
_mode=command bind move_shift_pgup { beg /v/search } { line /v/search }
_mode=command bind move_shift_pgdn { fin /v/search } { echo -n bottom of search buffer }
_mode=command bind ctrl_m { cmd=:(line /v/command); global cmd; at_fin /v/command && not { test -z :cmd } && echo | ins :_buf } { nop }
_mode=command bind ctrl_b { break } { nop }
_mode=command bind ctrl_q { exit } { nop }
_mode=command bind ctrl_r { echo -n search back } { cat; raise search_com_rev }
_mode=command bind ctrl_f { echo -n search } { cat; raise search_com_fwd }
_mode=command bind ctrl_g { nop } { raise search_com_again }
_mode=command bind ctrl_d { echo -n exit command } { cat; raise vip }
function commander() {
_mode=command _buf=/v/command loop {
key=:(raw -|xfkey)
eq :key ctrl_m && break
apply :key
}
cmd=:(line /v/command)
at_fin /v/command && (echo | ins /v/command)
vsh ":{cmd}"
fin /v/command
}
function search_com_fwd() {
searcher
srch_meth="srch_fwd /v/command :pattern" global srch_meth
:srch_meth
line /v/command
}
function search_com_rev() {
searcher
srch_meth="srch_back /v/command :{pattern}"; global srch_meth
:srch_meth
line /v/command
}
function search_com_again() {
test -z :srch_meth && bell && return
:srch_meth
line /v/command
}
function vish() { pop /v/meta | nop; raise com }
