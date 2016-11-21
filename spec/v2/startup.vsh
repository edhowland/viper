source editor.vsh
source command.vsh
source viper.vsh
source search.vsh
source delete.vsh
source debug.vsh
run=com
test -z :argv || run=vip
test -z :argv || exec {
for f in :(reverse :argv) { fopen :f }
}
:run

