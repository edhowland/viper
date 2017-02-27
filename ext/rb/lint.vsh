require ":{vhome}/ext/rb/lint_pass0.rb"
install_cmd LintPass0 /v/bin
require ":{vhome}/ext/rb/lint_pass1.rb"
install_cmd LintPass1 /v/bin
require ":{vhome}/ext/rb/lint_pass2.rb"
install_cmd LintPass2 /v/bin
require ":{vhome}/ext/rb/lint_pass3.rb"
install_cmd LintPass3 /v/bin
function lint() {
  mkdir /v/lint
  echo lint pass 0: indents are multiples of :indent
  lint_pass0 :_buf  | json -r /v/lint/0
  echo result was :(first :pipe_status)
  echo pass 1 indent distances are either 0 or :indent
  lint_pass1 :_buf | json -r /v/lint/1
      echo result was :(first :pipe_status)
  echo pass 2 trailing whitespace
  lint_pass2 :_buf | json -r /v/lint/2
    echo result was :(first :pipe_status)
  echo pass 3 check for excessive blank lineage
  lint_pass3 :_buf | json -r /v/lint/3
  echo result was :(first :pipe_status)
}
