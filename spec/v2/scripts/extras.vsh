alias snips='echo available snippets are; (b=:(pathmap "%f" :_ext); cd "/v/macros/:{b}"; ls)'
function timehash() {
  datetime | digest_sha1 -c 6
}
function new_clip() {
  h=:(timehash)
  cpath="/v/clip/:{h}"
  mkbuf :cpath
  _clip=:cpath; global _clip
  echo :cpath
}
function scratch() {
ss=:(cd /v/buf; count &(c) { not { eq 'scratch*' :c } } scratch*)
ns=:(expr 1 '+' :ss)
pth="/v/buf/scratch:{ns}"
open :(basename :pth)
echo -n buffer is now :(basename :pth)
}
function is_dirty(buf) {
  not { eq :(cat < ":{buf}/.digest") :(digest_sha1 < :buf) }
}
