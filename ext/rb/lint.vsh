require ":{vhome}/ext/rb/lint_pass0.rb"
install_cmd LintPass0 /v/bin
require ":{vhome}/ext/rb/lint_pass1.rb"
install_cmd LintPass1 /v/bin
require ":{vhome}/ext/rb/lint_pass2.rb"
install_cmd LintPass2 /v/bin
require ":{vhome}/ext/rb/lint_pass3.rb"
install_cmd LintPass3 /v/bin
function lint() {
  test -f /v/lint && rm /v/lint
  mkdir /v/lint
  lint_pass0 :_buf  | json -r /v/lint/0
   pass0=:(first :pipe_status)
  lint_pass1 :_buf | json -r /v/lint/1
   pass1=:(first :pipe_status)
  lint_pass2 :_buf | json -r /v/lint/2
   pass2=:(first :pipe_status)
  lint_pass3 :_buf | json -r /v/lint/3
  pass3=:(first :pipe_status)
  :pass0 && :pass1 && :pass2 && :pass3 && echo lint ok && return true
  :pass0 || echo lint pass 0: indents are multiples of :indent
  :pass1 || echo pass 1 indent distances are either 0 or :indent
  :pass2 || echo pass 2 trailing whitespace
  :pass3 || echo pass 3 check for excessive blank lineage
  echo lint failed
  return false
}
function gl(pass) {
  deq "/v/lint/:{pass}/lint_pass:{pass}"
}
