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
function mark_apply(fn,buf, mark) {
  mpos=:(trait_first :buf :mark)
  pos=:(decr :(position :buf))
  exec :fn :buf :mpos :pos
}
function mark_copy(buf, mark) {
  new_clip
  mark_apply &(buf, m, p) { within :buf :m :p } :buf :mark | cat > :_clip
}
function mark_cut(buf, mark) {
  new_clip
  mark_apply &(buf, m, p) { slice :buf :m :p } :buf :mark | cat > :_clip
}
function mark_exists(mark) {
  trait_exists :_buf :mark
  }
function mark_del(mark) {
  trait_del :_buf :mark
  }
function mark_line_extent(buf, m) {
  mark_apply &(buf, m, p) { p=:(incr :p); goto_position :buf :m; lm=:(line_number :buf); goto_position :buf :p; lp=:(line_number :buf); echo :lm :lp } :buf :m 
}
function mark_lines_apply(fn, buf, m) {
  _=:(mark_line_extent :buf :m)
  shift start; shift fini
  r=":{start}..:{fini}"
  for l in :r {
    goto :buf :l
    exec :fn :buf
  }
}
capture { new_clip } { echo caught :last_exception in :__FILE__; (test -f /v/clip/metadata/clips && echo /v/clip/metadata/clips exists) || echo /v/clip/metadata/clips does not exist }
_mark=_ ; global _mark

