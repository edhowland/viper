mkmode mark
function mark_keys() {
  for i in :_ {
key=:(echo -n :i | xfkey)
bind :key &() { trait_set :_buf :i; _mark=:i; global _mark } &() { echo -n mark :i set }
store { nop } "/v/klogs/:{_mode}/:{key}"
  }
}
_mode=mark mark_keys :(printable)
function m(mark) {
  trait_set :_buf :mark
  _mark=:mark; global _mark
}
function mark_first(mark) {
  goto_position :_buf :(trait_first :_buf :mark)
}
function mark_next(mark) {
   goto_position :_buf :(trait_next :_buf :mark)
}
function mark_prev(mark) {
  goto_position :_buf :(trait_prev :_buf :mark)
}
