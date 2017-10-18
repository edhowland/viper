mkmode macros
function snip_exists(name) {
ext=:(pathmap '%x' :_buf)
test -f "/v/macros/:{ext}/:{name}"
}
function snip_is(snip) {
val=:(  (test -z :snip && pathmap '%x' :(pathname)) || echo :snip)
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
  eq macro_start :(peek_keylog) && pop_keylog
}
function rm_macro(name, ext) {
  rm "/v/macros/:{ext}/:{name}"
}
function edit_macro(name, snip) {
  snip=:(snip_is :snip)
  mpath="/v/macros/:{snip}/:{name}"
  echo -n editing macro :name in :snip Use control z and alt z to undo and redo actions. Press F6 when done
  applyk fn_6
  rotate /v/editor/macroprompt
  play_macro :name :snip
}
function macros() {
  ext=:(pathmap '%x' :_buf)
  cd "/v/macros/:{ext}"
  echo available macros for :ext
  each &(m) { echo :m } *
  cd - | nop
}
_mode=macros bind meta_m &(data) { trait_set :_buf :data; _mark=:data; global _mark } &(data) { nop }
_mode=macros bind ins_at &(data) { key=:(echo -n :data | xfkey -r); ins_at :_buf :key } &(data) { nop }
store { echo "meta_m,:{_mark}" | enq ":{_buf}/.keylog" } /v/klogs/macros/meta_m
_mode=macros bind meta_d &(data) { new_clip; perform_delete :_sup } &(data) { nop }
function perform_macro() {
  each &(key) { apply :key } :_
}
function bind_macro() {
  shift key
  macro=:_
  bind :key &() { perform_macro :macro } { cat }
}
alias bm=bind_macro
function splitch() {
  ruby "puts args.join('').chars.join(' ')" :_
}
function bind_string() {
  shift key
  bind_macro :key :(map &(x) { echo -n :x | xfkey } :(splitch :_) )
}
