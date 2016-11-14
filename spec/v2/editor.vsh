function open(fname) {
bname=:(basename :fname)
_buf=/v/buf/:{bname}
mkbuf :_buf
global _buf
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
function apply(ch) { (key_exists :ch || bell) && applyf :ch | applys :ch }
_mode=viper; global _mode
echo mode is now :_mode
function mkmode(m) { mkdir /v/modes/:{m}; mkdir /v/views/:{m} }
mkmode viper
mkmode delete
mkmode search
indent=2; global indent
function vip() {
echo  now in :(basename :_buf)
loop { fn=:(raw -|xfkey); eq :fn escape && break; apply :fn }
}
