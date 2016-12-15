mkmode macros
function play_macro(name, snip) {
  mpath="/v/macros/:{snip}/:{name}"
  loop {
suppress { peek :mpath   || break }
  _=:(deq :mpath) 
ifs=',' shift key
data=''
test -z :_ || shift data
suppress { (_mode=macros key_exists :key && _mode=macros apply :key :data) || _mode=viper apply :key }
  }
}
_mode=macros bind meta_m &(data) { trait_set :_buf :data } &(data) { nop }
