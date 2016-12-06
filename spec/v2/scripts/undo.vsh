mkmode undo
function pop_keylog() {
  is_empty ":{_buf}/.keylog" && bell && return false
  _=:(deq ":{_buf}/.keylog")
  shift _key
  (test -z :_ && _data='') || shift _data
  global _key; global _data 
}
function undo() {
  pop_keylog || return false
eq ctrl_z :_key && pop_keylog || return false
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
each &(k) { _mode=undo bind :k { _mode=viper applyf key_backspace } { echo -n delete :(echo -n :key | xfkey -h)} } :keys
kname=:(echo -n ' '|xfkey)
_mode=undo bind :kname { _mode=viper applyf key_backspace } { echo -n delete space }
_mode=undo bind move_right { _mode=viper applyf move_left } { at :_buf }
_mode=undo bind move_left { _mode=viper applyf move_right } { at :_buf }
_mode=undo bind move_up { _mode=viper applyf move_down } {line  :_buf }
_mode=undo bind move_down { _mode=viper applyf move_up } { line :_buf }
_mode=undo bind key_backspace &(data) { _mode=vipercat < :data | ins :_buf } { cat }
_mode=undo bind ctrl_x &(clip) { cat < :clip | ins :_buf } &(data) { echo -n selection restored }
_mode=undo bind fn_4 { _mode=viper apply fn_4 } { cat }
_mode=undo bind ctrl_l { _mode=viper apply ctrl_l } { cat }

