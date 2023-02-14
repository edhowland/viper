rem functions.vsh
function handle_welcome_key() {
   key=:(raw - | xfkey)
   cond { eq :key ctrl_q } { exit } else { return }
}
function display_welcome() {
   test -e /v/buf || return
   test -X ":{lhome}/etc/no-viper-welcome-banner" || exec { cat ":{lhome}/share/viper/docs/welcome-banner.md"; handle_welcome_key }
}