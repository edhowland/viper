mkmode ins_at
function bind_ins(canon,value) {
  bind :canon &() { ins_at :_buf :value } { cat }
}
function mode_ins_at() {
for i in :_ {
key=:(echo -n :i | xfkey)
  bind_ins :key :i
}
}
_mode=ins_at mode_ins_at :(printable)
name=key_space
_mode=ins_at bind :name { ins_at :_buf ' ' } { echo -n space }
function do_ins_at() {
  key=:(raw - | xfkey)
  capture { _mode=ins_at apply :key } { bell }
}
