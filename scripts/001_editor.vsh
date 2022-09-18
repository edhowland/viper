function open(fname) {
bname=:(basename :fname)
rbuf=:(rand -c 0 5)
_buf=/v/buf/:{rbuf}
mkbuf :_buf
global _buf
mkarray ":{_buf}/.keylog"
mkarray ":{_buf}/.undones"
echo :_buf | enq /v/modes/viper/metadata/buffers
cat < :_buf | digest_sha1 > ":{_buf}/.digest"
echo ":{pwd}/:{bname}" > ":{_buf}/.pathname"
}
function fopen(fname) {
open :fname
rpath=:(realpath :fname)
echo :rpath > ":{_buf}/.pathname"
test -f :rpath && cat < :fname > :_buf && digest_sha1 -f :fname > ":{_buf}/.digest"
}
function pathname(buf) {
  test -z :buf && buf=:_buf
  cat < ":{buf}/.pathname"
}
function clone_buf(src, dest) {
  cp :src :dest
  bname=:(basename :dest)
  echo "/v/buf/:{bname}" | enq /v/modes/viper/metadata/buffers
}
function kill_buffer(buf) {
  rm :buf
  next
  pop /v/modes/viper/metadata/buffers | nop
  echo -n   now in :(buffer_name)
}
  alias k='kill_buffer :_buf'
function o(fname) { fopen :fname; (test -f :fname && apply fn_2) || echo -n new file ':' :fname }
function applyf(key, data) { exec "/v/modes/:{_mode}/:{key}" :data }
function applys(key, data) { exec "/v/views/:{_mode}/:{key}" :data }
function applyk(key, opt) {
(test -f "/v/klogs/:{_mode}/:{key}" && exec "/v/klogs/:{_mode}/:{key}" :opt) || log_key :key :opt
}
function bind(key, fn1, fn2) { store :fn1 /v/modes/:{_mode}/:{key}; store :fn2 /v/views/:{_mode}/:{key} }
function is_bound(key) {
  test -f "/v/modes/:{_mode}/:{key}"
}
function bound(key) {
  is_bound :key || exec { perr -e :key is not bound; return false }
  echo "_mode=:{_mode}" bind :key :(stat -s "/v/modes/:{_mode}/:{key}") :(stat -s "/v/views/:{_mode}/:{key}")
}
alias bk='echo -n Type a key to hear its bound action; bound :(raw - | xfkey)'
function unbind(key) {
  is_bound :key || exec { perr :key is not bound; return false }
  rm "/v/modes/:{_mode}/:{key}"
  rm "/v/views/:{_mode}/:{key}"
  test -f "/v/klogs/:{_mode}/:{key}" && rm "/v/klogs/:{_mode}/:{key}"
}
_keysink=.keylog; global _keysink
function key_exists(key) { test -f "/v/modes/:{_mode}/:{key}" }
function log_key(key, op) {
  test -f ":{_buf}/:{_keysink}" && ifelse { test -z :op } { echo :key | enq ":{_buf}/:{_keysink}" } { echo ":{key} :{op}" | enq ":{_buf}/:{_keysink}" }
}
function apply(ch, data) {
  applyf :ch :data | tee -e { applyk :ch } | applys :ch :data
}
_mode=viper; global _mode
function mkmode(m) {
mkdir /v/modes/:{m}
mkdir /v/views/:{m} 
mkdir /v/klogs/:{m}
}
function printable() {
uc=A..Z lc=a..z nu=0..9 pu1='!../' pu2=':..@' pu3='[..`' pu4='{..~'
echo :lc :uc :nu :pu1 :pu2 :pu3 :pu4
}
function bind_key(canon, ky) {
  bind :canon &() { ins :_buf :ky } { cat }
}
function mode_keys() {
for i in :_ {
key=:(echo -n :i | xfkey)
  bind_key :key :i
}
}
mkmode init
_mode=init mode_keys :(printable)
function clone_init(m) {
  cp /v/modes/init "/v/modes/:{m}"
  cp /v/views/init "/v/views/:{m}"
  cp /v/klogs/init "/v/klogs/:{m}"
}
clone_init viper
mkdir /v/modes/viper/metadata; mkarray /v/modes/viper/metadata/buffers
mkmode delete
clone_init search
clone_init command
indent=2; global indent
pglines=10; global pglines
function vip() {
resolve_ext :_buf
_mode=viper
loop {
fn=:(raw -|xfkey)
  exec { key_exists :fn && apply :fn } || echo key :fn is not bound 
}
}
function apply_times(n, key) {
r="1..:{n}"
for i in :r { apply :key }
}
function save_file(bname) {
cat < :bname > :(cat < ":{bname}/.pathname")
digest_sha1 < :_buf > ":{_buf}/.digest"
}
function save() {
save_file :_buf
}
function pager() {
r="1..:{pglines}"
capture { for i in :r { line :_buf; down :_buf } }
}
mkdir /v/clip/metadata
mkarray /v/clip/metadata/clips
function new_clip() {
  h=:(rand -c 0 5)
  cpath="/v/clip/:{h}"
  mkbuf :cpath
  _clip=:cpath; global _clip
echo :_clip | enq /v/clip/metadata/clips
}
function next_clip() {
  rotate /v/clip/metadata/clips
  _clip=:(peek /v/clip/metadata/clips)
  global _clip
}
function rew() {
  cline=:(line_number :_buf)
    cat < :(cat < ":{_buf}/.pathname") > :_buf
mkarray ":{_buf}/.keylog"
  digest_sha1 -f :(cat < ":{_buf}/.pathname") > ":{_buf}/.digest"
  g :cline
  echo -n :(buffer_name) restored 
}
mkdir /v/editor
mkarray /v/editor/bufstack
mkarray /v/editor/modestack
mkarray /v/editor/macroprompt
echo "Macro stored. Press command key  then save_macro name .extension (optionally)" | enq /v/editor/macroprompt
echo -n "Recording macro. Press F 6 again when done" | enq /v/editor/macroprompt
mkdir /v/macros
function select_all() {
beg :_buf; m _ ; fin :_buf
}
function tab_indent() {
r="1..:{indent}"
for i in :r { applyf key_space }
}
function handle_return() {
current=:(indent_level :_buf)
echo | ins :_buf
range="1..:{current}"
:autoindent &&  for i in :range { echo -n ' ' | ins :_buf }
}
function handle_backtab() {
r="1..:{indent}"
for i in :r { applyf fake_backspace }
}
function del_word_back(buf) {
word=:(word_back :buf)
test -z :word && return false
new_clip
len=:(echo -n :word | wc)
r="1..:{len}"
for i in :r { 
del :buf } | nop
echo -n :word > :_clip
}
function del_word_fwd(buf) {
word=:(word_fwd :buf)
test -z :word && return false
new_clip
len=:(echo -n :word | wc)
r="1..:{len}"
for i in :r { 
del_at :buf } | nop
echo -n :word > :_clip
}
function handle_tab() {
tab_indent :_buf
echo -n tab
}
function move_word() {
l=:(word_fwd :_buf | wc)
fwd_amt :_buf :l
srch_fwd :_buf "/\w+/"
}
function move_word_back() {
srch_back :_buf "/[^\w]\w+/"
fwd :_buf
}
autoindent=false; global autoindent
function bufs() {
  for i in :(cd /v/buf;ls) { echo "/v/buf/:{i}" }
}
function buffers() {
names=:(cd /v/buf; echo *)
for i in :names { echo "/v/buf/:{i}" }
}
function ignore_undo(key) {
  store { nop } "/v/klogs/viper/:{key}" 
}
function save_pos() {
_pos=:(position :_buf); global _pos
}
function log_key_pos(key) {
  store { echo ":{key},:{_pos}" | enq ":{_buf}/.keylog" } "/v/klogs/viper/:{key}"
}
function log_key_clip(key) {
store { echo ":{key},:{_clip}" | enq ":{_buf}/.keylog" } "/v/klogs/viper/:{key}"
}
function log_key_clip_sup(key) {
store { echo ":{key},:{_clip},:{_sup}" | enq ":{_buf}/.keylog" } "/v/klogs/viper/:{key}"
}
function log_key_mark(key) {
store { echo ":{key},:{_mark}" | enq ":{_buf}/.keylog" } "/v/klogs/viper/:{key}"
}
function same_count() {
  match=:(basename :(pathname))
  count &(y) { eq :match :y } :(map &(x) { basename :(pathname :x) } :(buffers))
}
function buffer_name() {
  echo -n buffer :(basename :(pathname))
  is_dirty  :_buf && echo -n '*'
  eq 1 :(same_count) || pathname
}
function g(num) {
  suppress { goto :_buf :num }
  line :_buf
}
alias buffer='apply fn_2'
function pop_if(m) {
  test -f :m && test -e :m || pop :m | nop
  }
alias swmode="raise"
function open_line_below(buf) {
  cond { at_fin :buf } {
    echo | ins :buf; back :_buf } else {
    back_of_line :buf; echo | ins :buf }
}
function open_line_above(buf) {
  cond { at_beg :buf } {
    echo | ins :buf } else {
    front_of_line :buf; echo | ins :buf }
  back :_buf
}
function safe_at(buf) {
  cond { at_fin :buf } { nop } else { at :_buf }
}
function start_of_line(buf) {
  save_pos
  cond { at_beg :buf } { nop } else {
    front_of_line :buf }
}
function end_of_line(buf) {
  save_pos
  cond { at_fin :buf } { nop } else {
    back_of_line :buf }
}
