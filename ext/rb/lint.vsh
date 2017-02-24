require ":{vhome}/ext/rb/lint_pass0.rb"
install_cmd LintPass0 /v/bin
require ":{vhome}/ext/rb/lint_pass1.rb"
install_cmd LintPass1 /v/bin
function lint() {
  echo lint pass 0: indents are multiples of :indent
  lint_pass0 :_buf
  echo lint pass 1: adjacent line indents are either the same or exactly :indent
  lint_pass1 :_buf
}
