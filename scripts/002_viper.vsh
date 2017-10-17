function cut_mark() {
cut :_buf | cat > :_clip
echo -n selection deleted
}
function del_cut() {
(mark_exists :_buf && cut_mark) || del_char
}
mkdir /v/macros/viper
kname=key_space
_mode=viper bind :kname { ins :_buf ' ' } { echo -n space }
_mode=viper bind move_down { capture { down :_buf; line :_buf } { bell } } { cat }
_mode=viper bind move_up { capture { up :_buf; line :_buf } { bell } } { cat }
_mode=viper bind move_left { capture { back :_buf } { bell } { at :_buf } } { cat }
_mode=viper bind move_right { capture { fwd :_buf } { bell } { at :_buf } } { cat }
_mode=viper bind ctrl_j { nop } { at :_buf }
_mode=viper bind meta_j { word_fwd :_buf } { cat }
ignore_undo meta_j
_mode=viper bind ctrl_k { nop } { col :_buf }
_mode=viper bind meta_k { nop } { indent_level :_buf }
ignore_undo meta_k
_mode=viper bind ctrl_l { nop } { line :_buf }
store { echo key_backspace :_clip | enq ":{_buf}/:{_keysink}" } /v/klogs/viper/key_backspace
_mode=viper bind ctrl_m { handle_return } { echo -n new line }
function next() { 
rotate /v/modes/viper/metadata/buffers; _buf=:(peek /v/modes/viper/metadata/buffers); global _buf
resolve_ext :_buf
}
function prev() {
 rotate -r /v/modes/viper/metadata/buffers; _buf=:(peek /v/modes/viper/metadata/buffers); global _buf 
resolve_ext :_buf
}
function rmbuf() {
  buf=:(deq /v/modes/viper/metadata/buffers)
  rm :buf
  _buf=:(peek /v/modes/viper/metadata/buffers); global _buf
  resolve_ext :_buf
  buffer_name
}
_mode=viper bind ctrl_t { next } { echo -n now in :(buffer_name) }
ignore_undo ctrl_t
_mode=viper bind meta_t { prev } { echo -n   now in  :(buffer_name) }
ignore_undo meta_t
_mode=viper bind ctrl_i { handle_tab } { cat }
_mode=viper bind key_backtab { handle_backtab } { echo -n back tab }
_mode=viper bind fn_2 { nop } { buffer_name }
_mode=viper bind meta_2 { nop } { buffer_name; echo -n ' path ' :(pathname :_buf) }
_mode=viper bind ctrl_s { save } { echo -n :(buffer_name) saved to :(pathname) }
_mode=viper bind move_shift_pgup { _pos=:(position :_buf); beg :_buf; global _pos } { line :_buf }
log_key_pos move_shift_pgup
_mode=viper bind move_shift_pgdn { _pos=:(position :_buf); fin :_buf; global _pos } { echo -n bottom of buffer }
log_key_pos move_shift_pgdn
_mode=viper bind ctrl_q { nop } { exit }
_mode=viper bind meta_a { _pos=:(position :_buf); global _pos; pager } { cat }
store { echo meta_a :_pos | enq ":{_buf}/.keylog" } /v/klogs/viper/meta_a
_mode=viper bind ctrl_p { nop } { echo -n Control p is not assigned }
_mode=viper bind move_shift_home { _pos=:(position :_buf); front_of_line :_buf; global _pos } { at :_buf }
log_key_pos move_shift_home
_mode=viper bind move_shift_end { _pos=:(position :_buf);  back_of_line :_buf; global _pos } { at :_buf }
log_key_pos move_shift_end
_mode=viper bind ctrl_o { back_of_line :_buf; echo | ins :_buf } { at :_buf }
_mode=viper bind fn_4 { trait_set :_buf _; _mark=_; global _mark } { echo -n mark set }
_mode=viper bind fn_5 { trait_set :_buf t; _mark=t; global _mark } { echo -n mark t set }
_mode=viper bind ctrl_c { capture { mark_copy :_buf :_mark; echo -n copy } { echo -n :last_exception } } { cat }
store { echo ctrl_c :_clip | enq ":{_buf}/:{_keysink}" } /v/klogs/viper/ctrl_c
_mode=viper bind ctrl_x { capture { mark_cut :_buf :_mark; echo -n cut } { echo -n :last_exception } } { cat }
store { echo ctrl_x :_clip | enq ":{_buf}/:{_keysink}" } /v/klogs/viper/ctrl_x
_mode=viper bind ctrl_y { new_clip; line :_buf | cat > :_clip } { echo -n One line yanked }
log_key_clip ctrl_y
_mode=viper bind meta_y { nop } { echo -n Alt y is not assigned }
_mode=viper bind ctrl_v { mypos=:(position :_buf); cat < :_clip | ins :_buf | nop; echo :mypos } { echo -n paste }
store { data=:(cat); echo "ctrl_v,:{data}" | enq ":{_buf}/:{_keysink}" } /v/klogs/viper/ctrl_v
_mode=viper bind move_shift_right { mark_exists :_mark || m _ ; echo -n 'lit ' :(at :_buf) } { cat; fwd :_buf }
_mode=viper bind move_shift_left { mark_exists :_mark || m _ ; echo -n 'lit ' :(at :_buf) } { cat; back :_buf }
_mode=viper bind ctrl_f { srch_dir=srch_fwd; global srch_dir; echo -n search } { cat; save_pos; raise search_vip_fwd }
log_key_pos ctrl_f
_mode=viper bind ctrl_r { srch_dir=srch_back; global srch_dir; echo -n search back } { cat; save_pos; raise search_vip_rev }
log_key_pos ctrl_r
_mode=viper bind ctrl_g { save_pos; fwd :_buf; search_vip_again } { cat }
log_key_pos ctrl_g
_mode=viper bind meta_d { new_clip; perr -n delete; do_delete } { cat } 
log_key_clip_sup meta_d
_mode=viper bind meta_l { line_number :_buf } { cat }
ignore_undo meta_l
_mode=viper bind fn_6 { nop } { peek /v/editor/macroprompt; rotate /v/editor/macroprompt }
_mode=viper bind fn_8  { nop } { echo selection is; copy :_buf }
_mode=viper bind ctrl_a { save_pos; select_all } { echo -n select all }
log_key_pos ctrl_a
_mode=viper bind ctrl_w { move_word } { word_fwd :_buf }
_mode=viper bind meta_w { move_word_back } { word_fwd :_buf }
_mode=viper bind meta_semicolon { echo -n command } { cat; raise commander }
ignore_undo meta_semicolon
_mode=viper bind fake_backspace { del :_buf } { echo -n delete :(xfkey | xfkey -h) }
store { logk=:(xfkey); echo "fake_backspace,:{logk}" | enq ":{_buf}/.keylog" } /v/klogs/viper/fake_backspace
_mode=viper bind fake_cut { applyf ctrl_x } { echo -n selection deleted }
log_key_clip fake_cut
_mode=viper bind key_backspace { (mark_exists _ && apply fake_cut) || apply fake_backspace } { cat }  
ignore_undo key_backspace
_mode=viper bind fake_delete { del_at :_buf } { echo -n delete :(xfkey | xfkey -h) }
store { echo fake_delete :(cat) | enq ":{_buf}/.keylog" } /v/klogs/viper/fake_delete
_mode=viper bind key_delete { (mark_exists _ && apply fake_cut) || apply fake_delete } { cat }
ignore_undo key_delete
_mode=viper bind ctrl_z { undo || bell } { cat }
store { nop } /v/klogs/viper/ctrl_z
_mode=viper bind meta_z { redo || bell } { cat }
_mode=viper bind meta_v { next_clip } { echo -n clip now contains :(head -n1 < :_clip) }
_mode=viper bind ctrl_n { scratch true } { cat }
ignore_undo ctrl_n
_mode=viper bind fn_1 { buffers | wc -l } { echo -n Viper Editor buffers :(cat) }
ignore_undo fn_1
_mode=viper bind fn_3 { key_prompt } { cat }
ignore_undo fn_3
_mode=viper bind meta_p { position :_buf } { echo -n position :(cat) }
_mode=viper bind meta_period { apply :(peek_keylog) } { cat }
ignore_undo meta_period
_mode=viper bind meta_r { save_pos; capture { mark_prev :_mark; line :_buf } { echo -n No further previous marks found } } { cat }
log_key_pos meta_r
_mode=viper bind meta_f { save_pos; capture { mark_next :_mark; line :_buf } { echo -n No further marks found } } { cat }
log_key_pos meta_f
_mode=viper bind meta_m { perr -n set mark; key=:(raw - | xfkey); _mode=mark apply :key } { cat }
log_key_mark meta_m
_mode=viper bind meta_comma { play_macro :(word_back :_buf) } { line :_buf }
_mode=viper bind meta_greater { indent_line :_buf } { echo -n line indented }
_mode=viper bind meta_less { outdent_line :_buf } { echo -n line outdented }
_mode=viper bind meta_number { comment_line :_buf } {line :_buf  }
_mode=viper bind meta_3 { uncomment_line :_buf } { line :_buf }
_mode=viper bind meta_h { nop } { help }
_mode=viper bind meta_n { perr -n press a key; do_ins_at } { cat }
ignore_undo meta_n
function search_vip_rev() {
searcher
compose_srch_cmd srch_back
exec :srch_cmd
line :_buf
}
function search_vip_fwd() {
searcher
compose_srch_cmd srch_fwd
exec :srch_cmd
line :_buf
}
function search_vip_again() {
test -l :srch_cmd || bell && return false
exec :srch_cmd
line :_buf
}

