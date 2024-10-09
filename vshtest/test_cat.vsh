mod test_cat {
function test_cat_w_stdin_flag() {
  mkdir /v/tmp
  for i in foo bar baz spam {
    echo -n :i > "/v/tmp/:{i}"
  }
  cd /v/tmp
  res=:(echo -n hello | cat foo bar - baz spam)
  assert_eq :res "foobarhellobazspam"
}
function test_cat_w_no_stdin_flag() {
  mkdir /v/tmp
  for i in foo bar baz spam {
    echo -n :i > "/v/tmp/:{i}"
  }
  cd /v/tmp
  res=:(cat foo bar baz spam)
  assert_eq :res "foobarbazspam"
}
function test_cat_redirection_in() {
  mkdir /v/tmp; cd /v/tmp
  echo -n alpha > alpha
  res=:(cat <alpha)
  assert_eq :res 'alpha'
}
function test_cat_redirection_out() {
  mkdir /v/tmp; cd /v/tmp
  echo -n hello | cat >h.txt
  test -f h.txt; assert_true :exit_status
}
function test_cat_both_redir_in_out() {
  mkdir /v/tmp; cd /v/tmp
  echo -n beta > beta
  cat < beta >gamma
  test -f gamma; assert_true :exit_status
  res=:(cat gamma)
  assert_eq :res 'beta'
}
}