# open_files.vsh the setup for the open_argv function
function open_vip_files() {
  cd :proj
  cond { not { test -z :_buf } } { nop }  { test -z :argv } { open unnamed1 } else {
    open_argv
  }
}