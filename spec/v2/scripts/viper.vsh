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
_mode=viper bind ctrl_k { nop } { col :_buf }
_mode=viper bind meta_k { nop } { indent_level :_buf }
_mode=viper bind ctrl_l { nop } { line :_buf }
_mode=viper bind key_backspace { del_cut } { cat }
_mode=viper bind ctrl_m { echo | ins :_buf } { echo -n new line }
_mode=viper bind key_delete { del_at :_buf } { echo -n delete :(xfkey | xfkey -h) }
function next() { rotate /v/modes/viper/metadata/buffers; _buf=:(peek /v/modes/viper/metadata/buffers); global _buf }
function prev() { rotate -r /v/modes/viper/metadata/buffers; _buf=:(peek /v/modes/viper/metadata/buffers); global _buf }
_mode=viper bind ctrl_t { next } { echo -n buffer is now :(basename :_buf) }
_mode=viper bind meta_y { prev } { echo -n buffer is now :(basename :_buf) }
_mode=viper bind ctrl_i { handle_tab } { echo -n tab }
_mode=viper bind key_backtab { apply_times :indent key_backspace } { echo -n back tab }
_mode=viper bind fn_2 { nop } { echo -n buffer :(basename :_buf) }
_mode=viper bind ctrl_s { save } { echo -n buffer :(basename :_buf) saved to :(cat < ":{_buf}/.pathname") }
_mode=viper bind move_shift_pgup { beg :_buf } { line :_buf }
_mode=viper bind move_shift_pgdn { fin :_buf } { echo -n bottom of buffer }
_mode=viper bind ctrl_q { nop } { exit }
_mode=viper bind ctrl_p { pager } { cat }
_mode=viper bind move_shift_home { front_of_line :_buf } { at :_buf }
_mode=viper bind move_shift_end { back_of_line :_buf } { at :_buf }
_mode=viper bind ctrl_o { back_of_line :_buf; echo | ins :_buf } { at :_buf }
_mode=viper bind fn_4 { toggle_mark  } { (mark_exists :_buf &&echo -n mark set) || echo -n mark unset }
_mode=viper bind fn_5 { tab_set :_buf } { echo -n Tab point set }
_mode=viper bind ctrl_c { copy :_buf | cat > :_clip } { echo -n copy }
_mode=viper bind ctrl_x { cut :_buf | cat > :_clip } { echo -n cut }
_mode=viper bind ctrl_y { line :_buf | cat > :_clip } { echo -n One line yanked }
_mode=viper bind ctrl_v { cat < :_clip | ins :_buf } { echo -n paste }
_mode=viper bind move_shift_right { mark_exists :_buf || mark :_buf; echo -n 'lit ' :(at :_buf) } { cat; fwd :_buf }
_mode=viper bind move_shift_left { mark_exists :_buf || mark :_buf; echo -n 'lit ' :(at :_buf) } { cat; back :_buf }
_mode=viper bind ctrl_f { echo -n search } { cat; raise search_vip_fwd }
_mode=viper bind ctrl_r { echo -n search back } { cat; raise search_vip_rev }
_mode=viper bind ctrl_g { fwd :_buf; search_vip_again } { cat }
_mode=viper bind meta_d { nop } { echo -n delete; do_delete } 
_mode=viper bind meta_l { line_number :_buf } { cat }
_mode=viper bind fn_6 { nop } { peek /v/editor/macroprompt; rotate /v/editor/macroprompt }
_mode=viper bind ctrl_a { select_all } { echo -n select all }
_mode=viper bind ctrl_w { move_word } { word_fwd :_buf }
_mode=viper bind meta_w { move_word_back } { word_fwd :_buf }
_mode=viper bind meta_semicolon { echo -n command } { cat; raise commander }
_mode=viper bind ctrl_b { break } { nop }
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

