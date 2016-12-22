alias snips='echo available snippets are; (b=:(pathmap "%f" :_ext); cd "/v/macros/:{b}"; ls)'
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
function split(val, sep) {
  ifs=:sep; echo :val
}
function indent_line(buf) {
  suppress {
    front_of_line :buf
    tab_indent
  }
}
function outdent_line(buf) {
  suppress {
    il=:(indent_level :buf)
    eq 0 :il && return false
    front_of_line :_buf
    apply_times :il move_right
    handle_backtab
  }
}
