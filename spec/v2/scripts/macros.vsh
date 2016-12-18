mkmode macros
function snip_is(snip) {
val=:(  (test -z :snip && pathmap '%x' :_buf) || echo :snip)
(test -z :val && echo viper) || echo :val
}
function save_macro(name, snip) {
snip=:(snip_is :snip)
  mpath="/v/macros/:{snip}/:{name}"
  mkarray :mpath
  for k in :(cat < ":{_buf}/.keylog" | between fn_6) { echo :k | enq :mpath }
}
function play_macro(name, snip) {
snip=:(snip_is :snip)
  mpath="/v/macros/:{snip}/:{name}"
  applyk macro_start
  for atom in :(cat < :mpath) {
  _=:atom
ifs=',' shift key
data=''
_sup=''
test -z :_ || shift data
test -z :_ || shift _sup
global _sup
suppress { (_mode=macros key_exists :key && _mode=macros apply :key :data) || _mode=viper apply :key }
  }
}
function undo_macro() {
 suppress {  loop {
  peek_keylog || break
  eq :(peek_keylog) macro_start  && break
  undo
  } }
}
_mode=macros bind meta_m &(data) { trait_set :_buf :data; _mark=:data; global _mark } &(data) { nop }
_mode=macros bind meta_d &(data) { new_clip; perform_delete :_sup } &(data) { nop }
