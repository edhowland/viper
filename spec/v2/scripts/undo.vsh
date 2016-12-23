mkmode undo
function peek_keylog() {
  peek ":{_buf}/.keylog"
}
function pop_keylog() {
  is_empty ":{_buf}/.keylog" && bell && return false
  _=:(deq ":{_buf}/.keylog")
  ifs=',' shift _key
_data=''
  (test -z :_ && _data='') || shift _data
  global _key; global _data 
}
function undo() {
  pop_keylog || return false
  _keysink=.undones _mode=undo apply :_key :_data
}
function redo() {
  key=:(deq ":{_buf}/.undones")
  apply :key
}
xf=&(ch) { echo -n :ch | xfkey }
global xf
keys=:(map :xf :(printable))
global keys
each &(k) { _mode=undo bind :k { _mode=viper applyf fake_backspace } { echo -n delete :(echo -n :key | xfkey -h)} } :keys
kname=:(echo -n ' '|xfkey)
_mode=undo bind :kname { _mode=viper applyf fake_backspace } { echo -n delete space }
_mode=undo bind move_right { _mode=viper applyf move_left } { at :_buf }
_mode=undo bind move_left { _mode=viper applyf move_right } { at :_buf }
_mode=undo bind move_up { _mode=viper applyf move_down } {line  :_buf }
_mode=undo bind move_down { _mode=viper applyf move_up } { line :_buf }
_mode=undo bind move_shift_home &(data) { goto_position :_buf :data } &(data) { at :_buf }
_mode=undo bind move_shift_end &(data) { goto_position :_buf :data } &(data) { at :_buf }
_mode=undo bind move_shift_pgup &(data) { goto_position :_buf :data } &(data) { line :_buf }
_mode=undo bind move_shift_pgdn &(data) { goto_position :_buf :data } &(data) { line :_buf }
_mode=undo for key in ctrl_m ctrl_o { bind :key { _mode=viper apply key_backspace } { cat } }
_mode=undo bind ctrl_i { _mode=viper apply key_backtab } { cat }
_mode=undo bind key_backtab { _mode=viper apply ctrl_i } { cat }
_mode=undo bind ctrl_x &(clip) { cat < :clip | ins :_buf } &(data) { echo -n selection restored }
_mode=undo bind fake_cut &(clip) { cat < :clip | ins :_buf } &(data) { echo -n selection restored }
_mode=undo bind ctrl_c &(clip) { i=:(index_of /v/clip/metadata/clips :clip); delete_at /v/clip/metadata/clips :i; rm :clip; _clip=:(peek /v/clip/metadata/clips); global _clip } &(clip) { echo -n copy undone }
_mode=undo bind fn_4 { _mode=viper apply fn_4 } { cat }
_mode=undo for key in ctrl_l ctrl_k ctrl_j { bind :key { _mode=viper apply :key } { cat } }
_mode=undo bind meta_semicolon { nop } { echo -n ignoring command key }
_mode=undo bind ctrl_v &(data) { slice :_buf :data :(decr :(position :_buf)) | nop } &(data) { echo -n paste undone }
_mode=undo bind meta_a &(data) { goto_position :_buf :data } &(data) { line :_buf }
_mode=undo bind ctrl_s { nop } { echo -n cannot unsave file }
_mode=undo bind ctrl_a &(data) { beg :_buf; mark_del _ ; goto_position :_buf :data} &(data) { echo -n buffer unselected }
_mode=undo bind ctrl_f &(data) { goto_position :_buf :data } &(data) { line :_buf }
_mode=undo bind ctrl_r &(data) { goto_position :_buf :data } &(data) { line :_buf }
_mode=undo bind ctrl_g &(data) { goto_position :_buf :data } &(data) { line :_buf }
_mode=undo bind ctrl_w { _mode=viper apply meta_w } { cat }
_mode=undo bind meta_w { _mode=viper apply ctrl_w } { cat }
_mode=undo bind meta_d &(data) { cat < :data | ins :_buf } &(data) { echo -n undeleted }
_mode=undo bind ctrl_y &(data) { cat < :data | ins :_buf } &(data) { echo -n line unyanked }
_mode=undo bind fake_delete &(data) { echo -n :data | ins :_buf; back :_buf } &(data) { echo -n :data }
_mode=undo bind fake_backspace &(data) { _mode=viper applyf :data } &(data) { _mode=viper applys :data }
_mode=undo bind meta_r &(data) { goto_position :_buf :data } &(data) { line :_buf }
_mode=undo bind meta_f &(data) { goto_position :_buf :data } &(data) { line :_buf }
_mode=undo bind meta_m &(data) { trait_del :_buf :data } &(data) { echo -n mark :data unset }
_mode=undo bind meta_comma { undo_macro } { echo -n macro expansion reversed }
_mode=undo bind meta_less { indent_line :_buf } { echo -n outdent reversednted }
_mode=undo bind meta_number { uncomment_line :_buf } { line :_buf }
_mode=undo bind meta_3 { comment_line :_buf } { line :_buf }
