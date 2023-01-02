rem open_files.vsh the setup for the open_argv function
function open_vip_files() {
  cd :proj
  cond { test -z :argv } { open unnamed1 } else {
    open_argv
  }
}