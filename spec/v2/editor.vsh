function open(fname) {
bname=:(basename :fname)
_buf=/v/buf/:{bname}
mkbuf :_buf
global _buf
echo "/v/buf/:{bname}" | enq /v/modes/viper/metadata/buffers
}
function fopen(fname) {
open :fname
rpath=:(realpath :fname)
echo :rpath > ":{_buf}/.pathname"
cat < :fname > :_buf
}
function applyf(key) { exec "/v/modes/:{_mode}/:{key}" }
function applys(key) { exec "/v/views/:{_mode}/:{key}" }
function bind(key, fn1, fn2) { store :fn1 /v/modes/:{_mode}/:{key}; store :fn2 /v/views/:{_mode}/:{key} }
function key_exists(key) { test -f "/v/modes/:{_mode}/:{key}" }
function bell() { ruby 'print "\a"' }
function apply(ch) { (key_exists :ch || bell) && applyf :ch | applys :ch }
_mode=viper; global _mode
echo mode is now :_mode
function mkmode(m) { mkdir /v/modes/:{m}; mkdir /v/views/:{m} }
mkmode viper
mkdir /v/modes/viper/metadata; mkarray /v/modes/viper/metadata/buffers
mkmode delete
mkmode search
indent=2; global indent
function vip() {
echo  now in :(basename :_buf)
loop { fn=:(raw -|xfkey); eq :fn escape && break; apply :fn }
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

