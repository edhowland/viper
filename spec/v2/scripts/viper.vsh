function del_char() {
del :_buf | echo -n delete :(xfkey | xfkey -h)
}
function cut_mark() {
cut :_buf | cat > :_clip
echo -n selection deleted
}
function del_cut() {
(mark_exists :_buf && cut_mark) || del_char
}
_mode=viper mode_keys :(printable)
kname=:(echo -n ' '|xfkey)
_mode=viper bind :kname { ins :_buf ' ' } { echo -n space }
_mode=viper bind move_down { capture { down :_buf; line :_buf } } { cat }
_mode=viper bind move_up { capture { up :_buf; line :_buf } } { cat }
_mode=viper bind move_left { back :_buf } { at :_buf }
_mode=viper bind move_right { fwd :_buf } { at :_buf }
_mode=viper bind ctrl_j { nop } { at :_buf }
_mode=viper bind meta_j { word_fwd :_buf } { cat }
_mode=viper bind ctrl_k { nop } { col :_buf }
_mode=viper bind meta_k { nop } { indent_level :_buf }
_mode=viper bind ctrl_l { nop } { line :_buf }
_mode=viper bind key_backspace { del_cut } { cat }
store { echo key_backspace :_clip | enq ":{_buf}/:{_keysink}" } /v/klogs/viper/key_backspace
_mode=viper bind ctrl_m { handle_return } { echo -n new line }
_mode=viper bind key_delete { del_at :_buf } { echo -n delete :(xfkey | xfkey -h) }
function next() { 
rotate /v/modes/viper/metadata/buffers; _buf=:(peek /v/modes/viper/metadata/buffers); global _buf 
resolve_ext :_buf
}
function prev() {
 rotate -r /v/modes/viper/metadata/buffers; _buf=:(peek /v/modes/viper/metadata/buffers); global _buf 
resolve_ext :_buf
}
_mode=viper bind ctrl_t { next } { echo -n buffer is now :(basename :_buf) }
ignore_undo ctrl_t
_mode=viper bind meta_t { prev } { echo -n buffer is now :(basename :_buf) }
ignore_undo meta_t
_mode=viper bind ctrl_i { handle_tab } { cat }
_mode=viper bind key_backtab { handle_backtab } { echo -n back tab }
_mode=viper bind fn_2 { nop } { echo -n buffer :(basename :_buf) }
ignore_undo fn_2
_mode=viper bind ctrl_s { save } { echo -n buffer :(basename :_buf) saved to :(cat < ":{_buf}/.pathname") }
_mode=viper bind move_shift_pgup { pos=:(position :_buf); beg :_buf; echo :pos } { line :_buf }
store { echo move_shift_pgup :(cat) | enq ":{_buf}/.keylog" } /v/klogs/viper/move_shift_pgup
_mode=viper bind move_shift_pgdn { pos=:(position :_buf); fin :_buf; echo :pos } { echo -n bottom of buffer }
store { echo move_shift_pgdn :(cat) | enq ":{_buf}/.keylog" } /v/klogs/viper/move_shift_pgdn
_mode=viper bind ctrl_q { nop } { exit }
_mode=viper bind meta_a { _pos=:(position :_buf); global _pos; pager } { cat }
store { echo meta_a :_pos | enq ":{_buf}/.keylog" } /v/klogs/viper/meta_a
_mode=viper bind ctrl_p { nop } { echo -n Control p is not assigned }
_mode=viper bind move_shift_home { pos=:(position :_buf); front_of_line :_buf; echo :pos } { at :_buf }
store { echo move_shift_home :(cat) | enq ":{_buf}/.keylog" } /v/klogs/viper/move_shift_home
_mode=viper bind move_shift_end { pos=:(position :_buf);  back_of_line :_buf; echo :pos } { at :_buf }
store { echo move_shift_end :(cat) | enq ":{_buf}/.keylog" } /v/klogs/viper/move_shift_end 
_mode=viper bind ctrl_o { back_of_line :_buf; echo | ins :_buf } { at :_buf }
_mode=viper bind fn_4 { toggle_mark  } { (mark_exists :_buf &&echo -n mark set) || echo -n mark unset }
_mode=viper bind fn_5 { tab_set :_buf } { echo -n Tab point set }
_mode=viper bind ctrl_c { new_clip; copy :_buf | cat > :_clip } { echo -n copy }
store { echo ctrl_c :_clip | enq ":{_buf}/:{_keysink}" } /v/klogs/viper/ctrl_c
_mode=viper bind ctrl_x { new_clip; cut :_buf | cat > :_clip } { echo -n cut }
store { echo ctrl_x :_clip | enq ":{_buf}/:{_keysink}" } /v/klogs/viper/ctrl_x
_mode=viper bind ctrl_y { new_clip; line :_buf | cat > :_clip } { echo -n One line yanked }
_mode=viper bind meta_y { nop } { echo -n Alt y is not assigned }
_mode=viper bind ctrl_v { mypos=:(position :_buf); cat < :_clip | ins :_buf | nop; echo :mypos } { echo -n paste }
store { echo ctrl_v :(cat) | enq ":{_buf}/:{_keysink}" } /v/klogs/viper/ctrl_v
_mode=viper bind move_shift_right { mark_exists :_buf || mark :_buf; echo -n 'lit ' :(at :_buf) } { cat; fwd :_buf }
_mode=viper bind move_shift_left { mark_exists :_buf || mark :_buf; echo -n 'lit ' :(at :_buf) } { cat; back :_buf }
_mode=viper bind ctrl_f { echo -n search } { cat; save_pos; raise search_vip_fwd }
log_key_pos ctrl_f
_mode=viper bind ctrl_r { echo -n search back } { cat; save_pos; raise search_vip_rev }
log_key_pos ctrl_r
_mode=viper bind ctrl_g { save_pos; fwd :_buf; search_vip_again } { cat }
log_key_pos ctrl_g
_mode=viper bind meta_d { nop } { echo -n delete; do_delete } 
_mode=viper bind meta_l { line_number :_buf } { cat }
_mode=viper bind fn_6 { nop } { peek /v/editor/macroprompt; rotate /v/editor/macroprompt }
_mode=viper bind ctrl_a { save_pos; select_all } { echo -n select all }
log_key_pos ctrl_a
_mode=viper bind ctrl_w { move_word } { word_fwd :_buf }
_mode=viper bind meta_w { move_word_back } { word_fwd :_buf }
_mode=viper bind meta_semicolon { echo -n command } { cat; raise commander }
_mode=viper bind ctrl_b { break } { nop }
_mode=viper bind ctrl_z { undo || bell } { cat }
store { nop } /v/klogs/viper/ctrl_z
_mode=viper bind meta_z { redo } { cat }
_mode=viper bind meta_v { next_clip } { echo -n clip now contains :(head -n1 < :_clip) }
_mode=viper bind ctrl_n { scratch } { cat }
ignore_undo ctrl_n
_mode=viper bind fn_1 { buffers | wc -l } { echo -n Viper Editor buffers :(cat) }
ignore_undo fn_1
function search_vip_rev() {
searcher
srch_meth="srch_back :{_buf} :{pattern}"; global srch_meth
:srch_meth
line :_buf
}
function search_vip_fwd() {
searcher
srch_meth="srch_fwd :{_buf} :{pattern}"; global srch_meth
:srch_meth
line :_buf
}
function search_vip_again() {
test -z :srch_meth && bell && return
:srch_meth 
line :_buf
}

