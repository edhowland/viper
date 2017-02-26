require ":{vhome}/ext/rb/lint_pass0.rb"
install_cmd LintPass0 /v/bin
require ":{vhome}/ext/rb/lint_pass1.rb"
install_cmd LintPass1 /v/bin
require ":{vhome}/ext/rb/lint_pass2.rb"
install_cmd LintPass2 /v/bin
function lint() {
  mkdir /v/lint
  echo lint pass 0: indents are multiples of :indent
  lint_pass0 :_buf  | json -r /v/lint/0
  echo result was :(first :pipe_status)
  echo pass 2 trailing whitespace
  lint_pass2 :_buf | json -r /v/lint/2
    echo result was :(first :pipe_status)
}
