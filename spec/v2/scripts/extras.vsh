alias snips='echo available snippets are; (b=:(pathmap "%f" :_ext); cd "/v/macros/:{b}"; ls)'
function timehash() {
  datetime | hashcode -r | encode64 -r
}
function new_clip() {
  h=:(timehash)
  cpath="/v/clips/:{h}"
  mkbuf :cpath
  echo :cpath
}
function scratch() {
ss=:(cd /v/buf; count &(c) { not { eq 'scratch*' :c } } scratch*)
ns=:(expr 1 '+' :ss)
pth="/v/buf/scratch:{ns}"
open :(basename :pth)
echo -n buffer is now :(basename :pth)
}
