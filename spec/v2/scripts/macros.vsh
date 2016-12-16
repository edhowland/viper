mkmode macros
function save_macro(name, snip) {
  mpath="/v/macros/:{snip}/:{name}"
  mkarray :mpath
  for k in :(cat < ":{_buf}/.keylog" | between fn_6 | reverse) { echo :k | enq :mpath }
}
function play_macro(name, snip) {
  mpath="/v/macros/:{snip}/:{name}"
  loop {
suppress { peek :mpath   || break }
  _=:(deq :mpath) 
ifs=',' shift key
data=''
_sup=''
test -z :_ || shift data
test -z :_ || shift _sup
global _sup
suppress { (_mode=macros key_exists :key && _mode=macros apply :key :data) || _mode=viper apply :key }
  }
}
_mode=macros bind meta_m &(data) { trait_set :_buf :data } &(data) { nop }
_mode=macros bind meta_d &(data) { new_clip; perform_delete :_sup } &(data) { nop }
