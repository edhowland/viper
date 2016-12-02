mkmode undo
function undo() {
  _=:(deq ":{_buf}/.keylog")
  shift key; shift data
eq ctrl_z :key && (_=:(deq ":{_buf}/.keylog"); shift key; shift data)
  _keysink=.undones _mode=undo apply :key :data
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
_mode=undo bind key_backspace &(key) { _mode=viper apply :key } { cat }
