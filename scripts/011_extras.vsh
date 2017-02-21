alias snips='echo available snippets are; (b=:(pathmap "%f" :_ext); cd "/v/macros/:{b}"; ls)'
function scratch(say) {
ss=:(cd /v/buf; count &(c) { not { eq 'scratch*' :c } } scratch*)
ns=:(expr 1 '+' :ss)
pth="/v/buf/scratch:{ns}"
open :(basename :pth)
test -z :say || echo -n buffer is now :(basename :pth)
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
comment_chars='#'; global comment_chars
function comment_line(buf) {
    il=:(indent_level :buf)
  front_of_line :_buf
  apply_times :il move_right
  echo -n :comment_chars | ins :buf
}
function uncomment_line(buf) {
  front_of_line :buf
  srch_fwd :buf :comment_chars
  eq :(at :buf | xfkey -d) :(echo -n :comment_chars | xfkey -d) && del_at :buf
}
alias in="mark_lines_apply &(b) { indent_line :b } :_buf"
alias out="mark_lines_apply &(b) { outdent_line :b } :_buf"
alias cmt="mark_lines_apply &(b) { comment_line :b } :_buf"
alias unc="mark_lines_apply &(b) { uncomment_line :b } :_buf"

