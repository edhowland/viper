function open(fname) {
bname=:(basename :fname)
_buf=/v/buf/:{bname}
mkbuf :_buf
global _buf
mkarray ":{_buf}/.keylog"
echo "/v/buf/:{bname}" | enq /v/modes/viper/metadata/buffers
}
function fopen(fname) {
open :fname
rpath=:(realpath :fname)
echo :rpath > ":{_buf}/.pathname"
test -f :rpath && cat < :fname > :_buf
}
function applyf(key) { exec "/v/modes/:{_mode}/:{key}" }
function applys(key) { exec "/v/views/:{_mode}/:{key}" }
function bind(key, fn1, fn2) { store :fn1 /v/modes/:{_mode}/:{key}; store :fn2 /v/views/:{_mode}/:{key} }
function key_exists(key) { test -f "/v/modes/:{_mode}/:{key}" }
function apply(ch) { (key_exists :ch || bell) && applyf :ch | applys :ch; test -f ":{_buf}/.keylog" && (echo  :ch | enq ":{_buf}/.keylog") }
_mode=viper; global _mode
function mkmode(m) { mkdir /v/modes/:{m}; mkdir /v/views/:{m} }
mkmode viper
mkdir /v/modes/viper/metadata; mkarray /v/modes/viper/metadata/buffers
mkmode delete
mkmode search
mkmode command
indent=2; global indent
pglines=10; global pglines
function vip() {
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
function save() {
cat < :_buf > :(cat < ":{_buf}/.pathname")
}
function pager() {
r="1..:{pglines}"
capture { for i in :r { line :_buf; down :_buf } }
}
function try(expr, ok) {
ifelse { suppress { capture { exec :expr } } } { exec :ok } { bell }
}
mkdir /v/clip
mkbuf /v/clip/a
_clip=/v/clip/a; global _clip
function rew() { cat < :(cat < ":{_buf}/.pathname") > :_buf }
mkdir /v/editor
mkarray /v/editor/bufstack
mkarray /v/editor/modestack
mkarray /v/editor/macroprompt
echo "Macro stored. Press Esc then save_macro name .extension (optionally)" | enq /v/editor/macroprompt
echo -n "Recording macro. Press F 6 again when done" | enq /v/editor/macroprompt
function change_modebuf(mode, buf) {
echo :_mode | push /v/editor/modestack
echo :_buf | push /v/editor/bufstack
_mode=:mode; global _mode
_buf=:buf; global _buf
}
function restore_modebuf() {
_mode=:(pop /v/editor/modestack); global _mode
_buf=:(pop /v/editor/bufstack); global _buf
}
mkdir /v/macros
function save_macro(name, snip) {
snip=:((test -z ":{snip}" && echo default) || echo :snip)
mpath="/v/macros/:{snip}/:{name}"
mkdir "/v/macros/:{snip}"
mkarray :mpath
for ch in :(cat < ":{_buf}/.keylog" | reverse | between fn_6) { echo :ch | push :mpath }
}
function playback(name, snip) {
snip=:((test -z ":{snip}" && echo default) || echo :snip)
mpath="/v/macros/:{snip}/:{name}"
for ch in :(cat < :mpath) { suppress { apply :ch } }
}
function select_all() {
beg :_buf; mark :_buf; fin :_buf
}
function tab_indent() {
apply_times :indent key_space
}
function handle_tab() {
snip=:(word_back :_buf)
len=:(echo -n :snip | wc)
r="1..:{len}"
test -z :snip || for i in :r { del :_buf }
snip_exists :snip && run_snip :snip && return
(tab_exists :_buf && tab_goto :_buf) || tab_indent :_buf
}
function snip_exists(name) {
ext=:(pathmap '%x' :_buf)
test -f "/v/macros/:{ext}/:{name}"
}
function run_snip(name) {
ext=:(pathmap '%x' :_buf)
suppress {
current=:(position :_buf)
playback :name :ext
goto_position :_buf :current
tab_exists :_buf && tab_goto :_buf
}
line :_buf
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
function toggle_mark() {  (mark_exists :_buf && unset_mark :_buf) || mark :_buf }

