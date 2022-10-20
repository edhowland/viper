function opr(fname) {
  f=:(realpath :fname)
  test -f :f && o :f
  echo :exit_status
}
