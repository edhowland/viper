# Use this line as pattern for some comments
alias rem=nop
mkdir /v/buf
_bufd=/v/buf; global _bufd
version=:(ruby 'puts Vish::VERSION')
# OS environment variables
function ifelse(expr, icl, ecl) { exec { exec :expr || exec { exec :ecl && false } } && exec :icl }
function debugging() { false }
function filter(f) {
for e in :_ { exec :f :e && echo -n :e ' ' }
}
function reject(f) {
for e in :_ { exec :f :e || echo -n :e ' ' }
}
function reduce(f, init) {
for e in :_ {
init=:(exec :f ":{init}" ":{e}")
}
echo :init
}
function map(f) {
for e in :_ { echo -n :(exec :f :e) :ofs }
}
function each(f) {
for e in :_ { exec :f :e }
}
function count(f) {
cnt=0
for i in :_ { exec :f :i && cnt=:(expr 1 '+' :cnt) }
echo :cnt
}
function decr(x) {
  expr :x '-' 1
}
function incr(x) {
  expr :x '+' 1
}
function first(item) {
  echo :item
}
function rest(_x) { echo :_ }
function empty() { test -z :_ }
function load_event() { nop }
function exit_event() { nop }
# 018_environment.vsh: Helper functions for access to users OS environment
function env(var) { ruby "print ENV[':{var}']" }
HOME=:(env HOME); global HOME
XDG_CONFIG_HOME=:(env XDG_CONFIG_HOME); test -z :XDG_CONFIG_HOME && XDG_CONFIG_HOME=":{HOME}/.config"
# Set some Vish variables
_vconfig=":{XDG_CONFIG_HOME}/vish"; global _vconfig
# _vpm_root is the location of all Vish Package Management files
_vpm_root=":{_vconfig}/vpm"; global _vpm_root
alias if=cond
mkdir /v/options
function split(val, sep) {
  ifs=:sep echo :val
}
function join(sep) {
  ofs=:sep echo :_
}
cmdlet range '{ out.puts(((args[0].to_i)..(args[1].to_i)).to_a.join(locals[:ofs])) }'
cmdlet printf '{out.puts(args[0] % args[1].to_i) }'
source ":{vhome}/local/vfs/bin/vfs.vsh"
phome=":{vhome}/local/vish/prelude";global phome
lhome=":{vhome}/local"
exit_code=0; global exit_code
echo about to source vish/prelude.vsh
cd ":{__DIR__}/prelude"
# source ":{vhome}/local/vish/prelude.vsh"
