rem process_l.vsh handler for -l option
function process_l(mod) {
  pth="/v/options/:{mod}/actual/l"
  test -d :pth && goto :_buf :(cat ":{pth}/1")
}