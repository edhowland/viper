function open(fname) {
bname=:(basename :fname)
_buf=/v/buf/:{bname}
mkbuf :_buf
global _buf
mkarray ":{_buf}/.keylog"
mkarray ":{_buf}/.undones"
echo "/v/buf/:{bname}" | enq /v/modes/viper/metadata/buffers
cat < :_buf | digest_sha1 > ":{_buf}/.digest"
}
function fopen(fname) {
open :fname
rpath=:(realpath :fname)
echo :rpath > ":{_buf}/.pathname"
test -f :rpath && cat < :fname > :_buf && digest_sha1 -f :fname > ":{_buf}/.digest"
}
function o(fname) { fopen :fname; (test -f :fname && apply fn_2) || echo -n new file ':' :fname }
function applyf(key, data) { exec "/v/modes/:{_mode}/:{key}" :data }
function applys(key, data) { exec "/v/views/:{_mode}/:{key}" :data }
function applyk(key, opt) {
(test -f "/v/klogs/:{_mode}/:{key}" && exec "/v/klogs/:{_mode}/:{key}" :opt) || log_key :key :opt
}
function bind(key, fn1, fn2) { store :fn1 /v/modes/:{_mode}/:{key}; store :fn2 /v/views/:{_mode}/:{key} }
_keysink=.keylog; global _keysink
function key_exists(key) { test -f "/v/modes/:{_mode}/:{key}" }
function log_key() {
test -f ":{_buf}/:{_keysink}" && echo :_ | enq ":{_buf}/:{_keysink}"
}
function apply(ch, data) {
(key_exists :ch || bell) && applyf :ch :data | tee -e { applyk :ch } | applys :ch :data
}
_mode=viper; global _mode
function mkmode(m) {
mkdir /v/modes/:{m}
mkdir /v/views/:{m} 
mkdir /v/klogs/:{m}
}
mkmode viper
mkdir /v/modes/viper/metadata; mkarray /v/modes/viper/metadata/buffers
mkmode delete
mkmode search
mkmode command
indent=2; global indent
pglines=10; global pglines
function vip() {
resolve_ext :_buf
_mode=viper
loop {
fn=:(raw -|xfkey)
 eq :fn escape && break; apply :fn 
}
}
function printable() {
uc=A..Z lc=a..z nu=0..9 pu1='!../' pu2=':..@' pu3='[..`' pu4='{..~'
echo :lc :uc :nu :pu1 :pu2 :pu3 :pu4
}
function mode_keys() {
for i in :_ {
key=:(echo -n :i | xfkey)
bind :key &() { ins :_buf :i } &() { echo -n :i }
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
function try(expr, ok) {
ifelse { suppress { capture { exec :expr } } } { exec :ok } { bell }
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
  cat < :(cat < ":{_buf}/.pathname") > :_buf
mkarray ":{_buf}/.keylog"
  digest_sha1 -f :(cat < ":{_buf}/.pathname") > ":{_buf}/.digest"
  echo -n :(basename :_buf) restored 
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
function buffer_name() {
  echo -n buffer :(basename :_buf) :(map &(f) { is_dirty :f && echo '*' } :_buf) }
}
function g(num) {
  goto :_buf :num
}
