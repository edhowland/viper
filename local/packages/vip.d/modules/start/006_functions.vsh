rem functions.vsh
function display_welcome() {
   test -e /v/buf || return
   test -X ":{lhome}/etc/no-viper-welcome-banner" || exec { cat ":{lhome}/share/viper/docs/welcome-banner.md"; key=:(raw - | xfkey) }
}